clear all;
close all;
addpath(genpath('C:\TDT\TDTMatlabSDK'));

% SET VARIABLES FOR THE ANALYSIS
list_files = {'20190906_SearchStim2_spk2_d03','20190916_SearchStim2_spk2_d01','20190918_SearchStim2_spk2_d02'};
polarity_flip = 'y'; % should be 'n' for the data of 9/5/18, 9/7/18, 9/17/18
DataTimeRange = [-0.1 0.4];
StimTimeRange = [0 0.1];
EpochDuration = diff(DataTimeRange);
% EpochStart = -0.1;%Enter the start of epoch in seconds relative to stimulus onset
% EpochEnd = 0.4;%Enter the end of epoch in seconds relative to stimulus onset
% EpochDuration=EpochEnd-EpochStart;

for ff=1:numel(list_files)
    Block = list_files{ff};
    Date = Block(1:8);
    TankDir = 'F:\TDT\Synapse\Tanks';%hardwired answer
    % TankName = strcat('Domo-',Date(3:end));%hardwired answer
%     TankName = 'Domo-180813-182551';%hardwired answer
    TankName = strcat('Domo-',Block(3:8));%hardwired answer
    BLOCK_PATH = fullfile(TankDir,TankName,Block);
    
    % ACCESSING TANK FILE
    data = TDTbin2mat(BLOCK_PATH,'TYPE',{'epocs','streams'},'CHANNEL',0);
    tempdata = TDTfilter(data, 'Tick', 'TIME', [DataTimeRange(1), EpochDuration]);
    
    % GET NEURONAL SIGNALS OF EACH STIMULUS PRESENTATION
    ReadAEP = tempdata.streams.AEP1.filtered;
    ReadMUA = tempdata.streams.MUA1.filtered;
    ReadRAW = tempdata.streams.Wav1.filtered;
    
    % RESHAPE DATA IN MATRIX
    nTrial = numel(ReadRAW); % total number of trials
    AEP = []; MUA = []; RAW = [];
    for n=1:nTrial
        AEP = cat(3,AEP,ReadAEP{n});
        MUA = cat(3,MUA,ReadMUA{n});
        RAW = cat(3,RAW,ReadRAW{n});
    end
    AEP = permute(AEP,[3 2 1]);
    MUA = permute(MUA,[3 2 1]);
    RAW = permute(RAW,[3 2 1]);
    
    % INVERSION OF THE DATA IF NECESSARY
    if polarity_flip=='y'
        disp('fixing the polarity inversion of PZ2 amplifier');
        AEP = -AEP; % polarity of the neural signal flipped!!
        MUA = -MUA; % polarity of the neural signal flipped!!
        RAW = -RAW; % polarity of the neural signal flipped!!
    end
    
    % GET SAMPLING FREQUENCY OF THE DATA
    fs.AEP = data.streams.AEP1.fs;
    fs.MUA = data.streams.MUA1.fs;
    fs.RAW = data.streams.Wav1.fs;
    % TIME
    t.AEP = linspace(DataTimeRange(1),DataTimeRange(2),size(AEP,2)) * 1000;
    t.MUA = linspace(DataTimeRange(1),DataTimeRange(2),size(MUA,2)) * 1000;
    t.RAW = linspace(DataTimeRange(1),DataTimeRange(2),size(RAW,2)) * 1000;
    
    % SUMMARIZE THE INFORMATION
    param.date = data.info.date;
    param.BlockName = data.info.blockname;
    param.nTrial = nTrial;
    param.nChannel = size(RAW,3);
    param.DataTimeRange = DataTimeRange;
    param.StimTimeRange = StimTimeRange;
    param.PolarityFlip = polarity_flip;
    
    % SAVE THE DATA
    save_file_name = strcat(param.BlockName(1:end-3),'raw');
    save(save_file_name,'param','AEP','MUA','RAW','fs','t');
    clear tempdata param AEP MUA RAW fs t
end