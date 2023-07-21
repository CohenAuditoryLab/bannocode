function [SMI_layer,BMI_layer] = getIndex_reDefLayer_antpost(ABB,layer,tpos)

ROOT_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results';
LIST_DIR = 'C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code';

% ABB = 'A'; % either A, B1 or B2
% layer = 'I'; % choose depth, either 'S' or 'G' or 'I'

load(fullfile(LIST_DIR,'RecordingDate_Both'));
SMI_pos = []; SMI_ant = [];
BMI_pos = []; BMI_ant = [];
% iPL_core = []; iPL_belt = [];
for ff=1:numel(list_RecDate)
    RecDate = list_RecDate{ff};
    
    % load SMI and BMI
    % SMI/BMI -- struct of 2D matrix
    % (channel) x (tpos) see MUA_property_ver2.m for details
    data_dir = fullfile(ROOT_DIR,RecDate,'RESP');
    if length(tpos)==5
        fName = strcat(RecDate,'_MUAProperty2'); % 1st - T triplet
    elseif length(tpos)==6
        fName = strcat(RecDate,'_MUAProperty2_ext'); % 1st - T+1 triplet
    end
    load(fullfile(data_dir,fName));
    
    % depth selection
    i_depth = zeros(length(sig_ch),1);
    if strcmp(layer,'S') % supragranular layer
        if ~isnan(uBorder)
            i_depth(1:uBorder-1) = 1;
        end
    elseif strcmp(layer,'I') % infragranular layer
        if ~isnan(lBorder)
            i_depth(lBorder:end) = 1;
        end
    elseif strcmp(layer,'G') % granular layer
        if ~isnan(uBorder*lBorder)
            i_depth(uBorder:lBorder-1) = 1;
        end
    end
    sig_ch(i_depth==0) = [];

    SMI_sig = SMI.(ABB); % choose triplet
    SMI_sig(i_depth==0,:) = [];
    SMI_sig(sig_ch==0,:) = [];

    BMI_sig = BMI.(ABB); % choose triplet
    BMI_sig(i_depth==0,:) = [];
    BMI_sig(sig_ch==0,:) = [];
    


    if i_AP == 1
        SMI_pos = cat(1,SMI_pos,SMI_sig);
        BMI_pos = cat(1,BMI_pos,BMI_sig);
    elseif i_AP == 0
        SMI_ant = cat(1,SMI_ant,SMI_sig);
        BMI_ant = cat(1,BMI_ant,BMI_sig);
    end
    
    clear SMI BMI
end
SMI_layer.pos = SMI_pos;
SMI_layer.ant = SMI_ant;
BMI_layer.pos = BMI_pos;
BMI_layer.ant = BMI_ant;


% % log transformation
% logSMI_core = log2(SMI_pos); logSMI_belt = log2(SMI_ant);
% logBMI_core = log2(BMI_pos); logBMI_belt = log2(BMI_ant);



% % SMI vs BMI
% list_tpos = {'1st','2nd','3rd','T-1','T'};
% n_tpos = length(list_tpos);
% figure('Position',[200 200 900 550]);
% for tpos=1:n_tpos
%     subplot(3,n_tpos,tpos);
%     plot(logSMI_core(:,tpos),BMI_pos(:,tpos),'or','MarkerFaceColor','w');
%     xlabel('log(SMI)'); ylabel('BMI'); 
%     title(list_tpos{tpos});
%     grid on;
%     subplot(3,n_tpos,tpos+n_tpos);
%     plot(logSMI_belt(:,tpos),BMI_ant(:,tpos),'ob','MarkerFaceColor','w');
%     xlabel('log(SMI)'); ylabel('BMI'); 
%     title(list_tpos{tpos});
%     grid on;
%     [r_core(tpos),p_core(tpos)] = corr(logSMI_core(:,tpos),BMI_pos(:,tpos));
%     [r_belt(tpos),p_belt(tpos)] = corr(logSMI_belt(:,tpos),BMI_ant(:,tpos));
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
