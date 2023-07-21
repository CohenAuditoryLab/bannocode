% function [SMI_layer,BMI_layer] = getIndex_reDefLayer_antpost(ABB,layer,tpos)

ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';

% ABB = 'A'; % either A, B1 or B2
% layer = 'I'; % choose depth, either 'S' or 'G' or 'I'

load(fullfile(LIST_DIR,'RecordingDate_Both'));
% SMI_pos = []; SMI_ant = [];
% BMI_pos = []; BMI_ant = [];
for ff=1:numel(list_RecDate)
    RecDate = list_RecDate{ff};

    % load data to obtain laminar information
    data_dir = fullfile(ROOT_DIR,RecDate,'RESP');
    fName = strcat(RecDate,'_MUAProperty2_ext'); % 1st - T+1 triplet
    load(fullfile(data_dir,fName));

    % depth selection
    i_depth = nan(24,1); % initialization
    % superficial layer
    if ~isnan(uBorder) % upper boundary
        % set superficial layer to zero
        i_depth(1:uBorder-1) = 0;
    end
    % infragranular layer
    if ~isnan(lBorder) % lower boundary
        % set infragranular layer to two
        i_depth(lBorder:end) = 2;
    end
    % granular layer
    if ~isnan(uBorder*lBorder)
        % set granular layer to one
        i_depth(uBorder:lBorder-1) = 1;
    end
    % make sure channel 17 to 24 be NaN in the data from 16-ch electrode
    nChannel = size(SMI.A,1);
    i_depth(nChannel+1:end) = NaN;

    % concatenate data
    depth_index(:,ff) = i_depth;
    clear i_depth
end

% save 
save('LayerAssignment','depth_index');