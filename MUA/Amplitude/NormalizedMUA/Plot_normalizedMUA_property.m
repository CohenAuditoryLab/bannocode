clear all

ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';

triplet_name = 'A'; % either A, B1 or B2
i_selectPL = 2; % 2 for 13.3Hz in small dF, 3 for 4.4Hz in large dF

load(fullfile(LIST_DIR,'RecordingDate_Both'));
SMI_core = []; SMI_belt = [];
BMI_core = []; BMI_belt = [];
iPL_core = []; iPL_belt = [];
for ff=1:numel(list_RecDate)
    RecDate = list_RecDate{ff};
    
    % load SMI and BMI
    % SMI/BMI -- struct of 2D matrix
    % (channel) x (tpos) see MUA_property_ver2.m for details
    data_dir = fullfile(ROOT_DIR,RecDate,'RESP');
%     fName = strcat(RecDate,'_MUAProperty2');
    fName = strcat(RecDate,'_MUAProperty_normalize');
    load(fullfile(data_dir,fName));
    
    % load nPeak_all
    % nPeak_all -- 4D matrix 
    % (4.4Hz vs 13.3Hz) x (channel) x (stdiff) x (hit-miss)
    data_dir2 = fullfile(ROOT_DIR,RecDate,'FFT');
    fName2 = strcat(RecDate,'_FFT');
    load(fullfile(data_dir2,fName2));
    
    SMI_sig = SMI.(triplet_name); % try A tone...
%     SMI_sig(sig_ch==0,:) = NaN;
    SMI_sig(sig_ch==0,:) = [];

    BMI_sig = BMI.(triplet_name); % try A tone...
    BMI_sig(sig_ch==0,:) = [];
    
    iPL = [squeeze(nPeak_all(1,:,1,1)); ... % 4.4Hz small dF
           squeeze(nPeak_all(2,:,1,1)); ...  % 13.3Hz small dF
           squeeze(nPeak_all(1,:,end,1)); ... % 4.4Hz large dF
           squeeze(nPeak_all(2,:,end,1))]; % 13.3Hz large dF
    iPL_sig = iPL'; % transpose to make the first dim to be channel...
    iPL_sig(sig_ch==0,:) = [];
    
    if i_area == 1
        SMI_core = cat(1,SMI_core,SMI_sig);
        BMI_core = cat(1,BMI_core,BMI_sig);
        iPL_core = cat(1,iPL_core,iPL_sig);
    elseif i_area == 0
        SMI_belt = cat(1,SMI_belt,SMI_sig);
        BMI_belt = cat(1,BMI_belt,BMI_sig);
        iPL_belt = cat(1,iPL_belt,iPL_sig);
    end
    
end
% iMUAprop_core = [SMI_core iPL_core];
% iMUAprop_belt = [SMI_belt iPL_belt];

logPL_core = log2(iPL_core); logPL_belt = log2(iPL_belt);
logSMI_core = log2(SMI_core); logSMI_belt = log2(SMI_belt);
logBMI_core = log2(BMI_core); logBMI_belt = log2(BMI_belt);

% plot SMI/BMI wrt phase-loking index
list_tpos = {'1st','2nd','3rd','T-1','T'};
n_tpos = length(list_tpos);
figure('Position',[100 100 900 550]);
for tpos=1:n_tpos
    subplot(3,n_tpos,tpos);
    plot(logPL_core(:,i_selectPL),logSMI_core(:,tpos),'or','MarkerFaceColor','w');
    xlabel('log(FFT)'); ylabel('log(SMI)'); 
    title(list_tpos{tpos});
    grid on;
    subplot(3,n_tpos,tpos+n_tpos);
    plot(logPL_belt(:,i_selectPL),logSMI_belt(:,tpos),'ob','MarkerFaceColor','w');
    xlabel('log(FFT)'); ylabel('log(SMI)'); 
    title(list_tpos{tpos});
    grid on;
    [r_core(tpos),p_core(tpos)] = corr(logPL_core(:,i_selectPL),logSMI_core(:,tpos),'Type','Spearman');
    [r_belt(tpos),p_belt(tpos)] = corr(logPL_belt(:,i_selectPL),logSMI_belt(:,tpos),'type','Spearman');
end
subplot(3,2,5);
plot(1:n_tpos,r_core,'-or','LineWidth',2); hold on;
plot(1:n_tpos,r_belt,'-ob','LineWidth',2);
plot([0.5 n_tpos+0.5],[0 0],':k');
for tpos=1:n_tpos % fill circle if correlation is significant
    if p_core(tpos) < 0.05
        plot(tpos,r_core(tpos),'or','MarkerFaceColor','r');
    end
    if p_belt(tpos) < 0.05
        plot(tpos,r_belt(tpos),'ob','MarkerFaceColor','b');
    end
end
set(gca,'XLim',[0.5 n_tpos+0.5],'XTick',1:n_tpos,'XTickLabel',list_tpos);
xlabel('triplet posiion'); ylabel('correlation');
title('FFT vs SMI');
box off;

figure('Position',[150 150 900 550]);
for tpos=1:n_tpos
    subplot(3,n_tpos,tpos);
    plot(logPL_core(:,i_selectPL),BMI_core(:,tpos),'or','MarkerFaceColor','w');
    xlabel('log(FFT)'); ylabel('BMI'); 
    title(list_tpos{tpos});
    grid on;
    subplot(3,n_tpos,tpos+n_tpos);
    plot(logPL_belt(:,i_selectPL),BMI_belt(:,tpos),'ob','MarkerFaceColor','w');
    xlabel('log(FFT)'); ylabel('BMI'); 
    title(list_tpos{tpos});
    grid on;
    [r_core(tpos),p_core(tpos)] = corr(logPL_core(:,i_selectPL),BMI_core(:,tpos));
    [r_belt(tpos),p_belt(tpos)] = corr(logPL_belt(:,i_selectPL),BMI_belt(:,tpos));
end
subplot(3,2,5);
plot(1:n_tpos,r_core,'-or','LineWidth',2); hold on;
plot(1:n_tpos,r_belt,'-ob','LineWidth',2);
plot([0.5 n_tpos+0.5],[0 0],':k');
for tpos=1:5 % fill circle if correlation is significant
    if p_core(tpos) < 0.05
        plot(tpos,r_core(tpos),'or','MarkerFaceColor','r');
    end
    if p_belt(tpos) < 0.05
        plot(tpos,r_belt(tpos),'ob','MarkerFaceColor','b');
    end
end
set(gca,'XLim',[0.5 n_tpos+0.5],'XTick',1:5,'XTickLabel',list_tpos);
xlabel('triplet position'); ylabel('correlation');
title('FFT vs BMI');
box off;

% SMI vs BMI
figure('Position',[200 200 900 550]);
for tpos=1:n_tpos
    subplot(3,n_tpos,tpos);
    plot(logSMI_core(:,tpos),BMI_core(:,tpos),'or','MarkerFaceColor','w');
    xlabel('log(SMI)'); ylabel('BMI'); 
    title(list_tpos{tpos});
    grid on;
    subplot(3,n_tpos,tpos+n_tpos);
    plot(logSMI_belt(:,tpos),BMI_belt(:,tpos),'ob','MarkerFaceColor','w');
    xlabel('log(SMI)'); ylabel('BMI'); 
    title(list_tpos{tpos});
    grid on;
    [r_core(tpos),p_core(tpos)] = corr(logSMI_core(:,tpos),BMI_core(:,tpos));
    [r_belt(tpos),p_belt(tpos)] = corr(logSMI_belt(:,tpos),BMI_belt(:,tpos));
end
subplot(3,2,5);
plot(1:n_tpos,r_core,'-or','LineWidth',2); hold on;
plot(1:n_tpos,r_belt,'-ob','LineWidth',2);
plot([0.5 n_tpos+0.5],[0 0],':k');
for tpos=1:5 % fill circle if correlation is significant
    if p_core(tpos) < 0.05
        plot(tpos,r_core(tpos),'or','MarkerFaceColor','r');
    end
    if p_belt(tpos) < 0.05
        plot(tpos,r_belt(tpos),'ob','MarkerFaceColor','b');
    end
end
set(gca,'XLim',[0.5 n_tpos+0.5],'XTick',1:5,'XTickLabel',list_tpos);
xlabel('triplet position'); ylabel('correlation');
title('SMI vs BMI');
box off;

% % log transform
% ilProp_core = log10(iMUAprop_core);
% ilProp_belt = log10(iMUAprop_belt);
% 
% ilProp_all = [ilProp_core; ilProp_belt];
% 
% [coeff,score] = pca(ilProp_all);
% n = size(ilProp_core,1);
% score_core = score(1:n,:);
% score_belt = score(n+1:end,:);
% plot3(score_core(:,1),score_core(:,2),score_core(:,3),'or'); hold on
% plot3(score_belt(:,1),score_belt(:,2),score_belt(:,3),'^b'); 
% grid on;
