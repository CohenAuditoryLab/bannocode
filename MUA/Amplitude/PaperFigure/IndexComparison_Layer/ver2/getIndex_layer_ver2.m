function [SMI_layer,BMI_layer] = getIndex_layer_ver2(ABB,layer)

ROOT_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';

% ABB = 'A'; % either A, B1 or B2
% layer = 'I'; % choose depth, either 'S' or 'G' or 'I'

load(fullfile(LIST_DIR,'RecordingDate_Both'));
SMI_core = []; SMI_belt = [];
BMI_core = []; BMI_belt = [];
% iPL_core = []; iPL_belt = [];
for ff=1:numel(list_RecDate)
    RecDate = list_RecDate{ff};
    
    % load SMI and BMI
    % SMI/BMI -- struct of 2D matrix
    % (channel) x (tpos) see MUA_property_ver2.m for details
    data_dir = fullfile(ROOT_DIR,RecDate,'RESP');
    fName = strcat(RecDate,'_MUAProperty2');
    load(fullfile(data_dir,fName));
    
    % depth selection
    i_depth = zeros(length(sig_ch),1);
    if strcmp(layer,'S') % supragranular layer
        if ~isnan(ch_L3)
            i_depth(1:ch_L3-1) = 1;
        end
    elseif strcmp(layer,'I') % infragranular layer
        if ~isnan(ch_L5)
            i_depth(ch_L5:end) = 1;
        end
    elseif strcmp(layer,'G') % granular layer
        if ~isnan(ch_L3*ch_L5)
            i_depth(ch_L3:ch_L5-1) = 1;
        end
    end
    sig_ch(i_depth==0) = [];

    SMI_sig = SMI.(ABB); % choose triplet
    SMI_sig(i_depth==0,:) = [];
    SMI_sig(sig_ch==0,:) = [];

    BMI_sig = BMI.(ABB); % choose triplet
    BMI_sig(i_depth==0,:) = [];
    BMI_sig(sig_ch==0,:) = [];
    


    if i_area == 1
        SMI_core = cat(1,SMI_core,SMI_sig);
        BMI_core = cat(1,BMI_core,BMI_sig);
    elseif i_area == 0
        SMI_belt = cat(1,SMI_belt,SMI_sig);
        BMI_belt = cat(1,BMI_belt,BMI_sig);
    end
    
    clear SMI BMI
end
SMI_layer.core = SMI_core;
SMI_layer.belt = SMI_belt;
BMI_layer.core = BMI_core;
BMI_layer.belt = BMI_belt;


% % log transformation
% logSMI_core = log2(SMI_core); logSMI_belt = log2(SMI_belt);
% logBMI_core = log2(BMI_core); logBMI_belt = log2(BMI_belt);



% % SMI vs BMI
% list_tpos = {'1st','2nd','3rd','T-1','T'};
% n_tpos = length(list_tpos);
% figure('Position',[200 200 900 550]);
% for tpos=1:n_tpos
%     subplot(3,n_tpos,tpos);
%     plot(logSMI_core(:,tpos),BMI_core(:,tpos),'or','MarkerFaceColor','w');
%     xlabel('log(SMI)'); ylabel('BMI'); 
%     title(list_tpos{tpos});
%     grid on;
%     subplot(3,n_tpos,tpos+n_tpos);
%     plot(logSMI_belt(:,tpos),BMI_belt(:,tpos),'ob','MarkerFaceColor','w');
%     xlabel('log(SMI)'); ylabel('BMI'); 
%     title(list_tpos{tpos});
%     grid on;
%     [r_core(tpos),p_core(tpos)] = corr(logSMI_core(:,tpos),BMI_core(:,tpos));
%     [r_belt(tpos),p_belt(tpos)] = corr(logSMI_belt(:,tpos),BMI_belt(:,tpos));
% end
% subplot(3,2,5);
% plot(1:n_tpos,r_core,'-or','LineWidth',2); hold on;
% plot(1:n_tpos,r_belt,'-ob','LineWidth',2);
% plot([0.5 n_tpos+0.5],[0 0],':k');
% for tpos=1:5 % fill circle if correlation is significant
%     if p_core(tpos) < 0.05
%         plot(tpos,r_core(tpos),'or','MarkerFaceColor','r');
%     end
%     if p_belt(tpos) < 0.05
%         plot(tpos,r_belt(tpos),'ob','MarkerFaceColor','b');
%     end
% end
% set(gca,'XLim',[0.5 n_tpos+0.5],'XTick',1:5,'XTickLabel',list_tpos);
% xlabel('triplet position'); ylabel('correlation');
% title('SMI vs BMI');
% box off;

end
