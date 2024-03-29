function pre_process_v3(sevpath,block,fdest,method)
% for Tank file which does not has sev files...
fs=24414.0625;
%Notch 60Hz IIR
bsFilti = designfilt('bandstopiir','FilterOrder',20, ...
         'HalfPowerFrequency1',50,'HalfPowerFrequency2',70, ...
         'SampleRate',fs);
%iir BP     
bpFilti = designfilt('bandpassiir','FilterOrder',20, ...
         'HalfPowerFrequency1',300,'HalfPowerFrequency2',5e3, ...
         'SampleRate',fs);
     
nChan = 24; %16;%64 for Jan03_19 look at notes 96;
% sevpath=[sevpath '\Block-' num2str(block) '\'];
sevpath=[sevpath '\' num2str(block) '\'];
s_bin=0.15;

% %ML XPZ5 1-64 XPZ2 1-32
% %AL XPZ2 33-128
% session     =   raw{indexn(n),4};
% block       =   raw{indexn(n),6};
% task        =   raw{indexn(n),7};
% if strcmp(task(1),'S') && (length(task)>4) 
  
% fns=dir([sevpath '*.sev']);
% in_block=strfind(fns(1).name,'xpz');
% in_block=strfind(fns(1).name,'RAW1');
%for XPZ2
%sevfilename=[fns(1).name(1:in_block+2) num2str(2) '_ch' num2str(i) '.sev'];
% folder_path=['C:\work\temp_fil\AL'];%'c:\work\SAM-190103\xpz2b3';
folder_path = ['D:\Cassius\KSSpikeSorting\temp'];
if ~exist(folder_path,'dir')
    mkdir(folder_path)
end
folder_remove1=folder_path;
pf=tic;
% first_part_file=fns(1).name(1:in_block+2);
% first_part_file=fns(1).name(1:in_block+3);
data = TDTbin2mat(sevpath,'TYPE',{'streams'},'CHANNEL',0);
data_channels = data.streams.RAW1.data;
for i = 1:nChan %will do filtering and re-reference in this loop
    tic
%     sevfilename=[first_part_file num2str(2) '_ch' num2str(i+32) '.sev'];
    first_part_file = strcat(block,'_RAW1');
    sevfilename=[first_part_file '_ch' num2str(i) '.sev'];
    fprintf('Channel %02d/%02d: ',i,nChan);
%     fn = fullfile(sevpath,sevfilename);
%     fid = fopen(fn,'r'); %open channel
%     header = fread(fid,10,'*single');
%     dat_temp = fread(fid,[1,inf],'*single');
% %     dat_temp = fread(fid,[1,inf],'*single') * -1; % 2/27/19 modified to flip the data
%     fclose(fid);
    dat_temp = data_channels(i,:);
    %filtering
    dataBS=filtfilt(bsFilti,double(dat_temp));     
    dataIIR=filtfilt(bpFilti,dataBS);
    %reference
    tic;
        fprintf('offset removal... ');
        if strcmp(method,'median')
            % subtract the median
            dataIIR = dataIIR - median(dataIIR);
        elseif strcmp(method,'mean')
            % subtract the mean
            dataIIR = dataIIR - mean(dataIIR);
        end
        fprintf('(%4.2f secs) ',toc);
    
    %saving to C:\work\temp_fil
    
    %fidOut(i) = fopen(fullfile(folder_path,sevfilename),'w'); %open channel, stay open.
    
    fidOut = fopen(fullfile(folder_path,sevfilename),'w'); %open channel, stay open.
    while fidOut ==-1
        pause(1)
        fidOut = fopen(fullfile(folder_path,sevfilename),'w');
    end
    %dataIIR = int16(data.*1e6);
    fwrite(fidOut,dataIIR,'*single');
    %fwrite(fidOut(i),dataIIR,'*single');
    fclose(fidOut);
    fprintf('%4.2f secs\n',toc);
end
  fprintf('ParFor:(%4.2f secs)\n',toc(pf));
%Second pass re-reference 

fprintf('PASS 2: COMMON AVERAGE REFERENCING.\n')
      % open the output file
%      chunkSize   = 10e6;
    chunkSize   = 5e5;
     d           = dir((fullfile(folder_path ,'*.sev')));
     nSampsTotal = d(1).bytes/4;
    chunkSize    = min(chunkSize,nSampsTotal);
    nChunksTotal = ceil(nSampsTotal/chunkSize);
   ca=tic;
% folder_pathd=[fdest '_AL'];%'c:\work\SAM-190103\xpz2b3';
folder_pathd = fdest;

if ~exist(folder_pathd,'dir')
    mkdir(folder_pathd)
end
fnOut_c = fullfile(folder_pathd,'continuous.dat');
fidOut_c = fopen(fnOut_c,'W');



% loop through the data, loading and re-referencing
    chunkInd = 1;
    while 1
        t1 = tic;
        if chunkInd <= nChunksTotal
            fprintf('PASS 2: Chunk %03d/%03d: loading... ',chunkInd,nChunksTotal);

            tic
            if chunkInd < nChunksTotal
                buff = chunkSize;
            elseif chunkInd == nChunksTotal
                buff = nSampsTotal - chunkSize*(chunkInd-1);
            end
            dat = zeros(nChan,buff);
            for i = 1:nChan
                % open for the first chunk
                if chunkInd == 1
%                     sevfilename=[d(1).name(1:in_block+2) num2str(2) '_ch' num2str(i+32) '.sev'];
%                     sevfilename=[d(1).name(1:in_block+3) '_ch' num2str(i) '.sev'];
                    sevfilename=[first_part_file '_ch' num2str(i) '.sev'];
                    chfid(i) = fopen(fullfile(folder_path,sevfilename),'r');
                end
                
                % read the data
                dat(i,:) = fread(chfid(i),[1,buff],'*single');
            end
            fprintf('(%4.2f secs) ',toc);

            tic
            fprintf('re-referencing... ');
            % remove the 'average', but do not use bad channels in the
            % average
            if strcmp(method,'median')  %% Need to change to . operation faster
               % tm = median(dat,1);
                dat=dat-(median(dat));
                %dat = bsxfun(@minus, dat, tm); % subtract median of each time point
            elseif strcmp(method,'mean')
               % tm = mean(dat(connected,:),1);
                dat=dat-(mean(dat));
                %dat = bsxfun(@minus, dat, tm); % subtract mean of each time point
            end
            fprintf('(%4.2f secs) ',toc);
            tic
            fprintf('writing... ');
            dat=int16(dat.*1e6);
            fwrite(fidOut_c, dat, '*int16');
            fprintf('(%4.2f secs)\n',toc);
        else
            break
        end
        chunkInd = chunkInd + 1;
        fprintf('\tChunk time: %4.2f secs\n',toc(t1));
    end

% fwrite(fidOut,datf(:),'*int16');
 fclose(fidOut_c);
 fclose all;
toc(ca);
clear datf dat
[~, ~, ~] =rmdir(folder_remove1, 's');%removing temporal folders
% [~, ~, ~] =rmdir(folder_remove2, 's');