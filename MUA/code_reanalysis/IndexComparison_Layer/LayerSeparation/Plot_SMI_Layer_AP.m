clear all;
addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code_reanlysis\IndexComparison_Layer');

ABB = 'A'; % choose 'A', 'B1' or 'B2'
Layer = {'S','G','I'};
% Layer = {'S','I'}; 
% tpos = {'1st','2nd','3rd','T-1','T'};
tpos = {'1st','2nd','3rd','T-1','T','T+1'};
if strcmp(ABB,'A')
    slabel = 'log(CI)';
else
    slabel = 'log(FSI)';
end

% line color
color_core = [157 195 230; 46 117 182; 31 78 121] / 255;
color_belt = [244 177 131; 197 90 17; 132 60 12] / 255;

% jitter in errorbar
if numel(Layer)==2 
    jitter = [-0.15 -0.05 0.05 0.15];
elseif numel(Layer)==3
    jitter = [-0.25 -0.15 -0.05 0.05 0.15 0.25];
end

pos = [1 3 4];
% figure;
for i=1:length(ABB) % index for ABB triplet
    for j=1:length(Layer) % index for layer
        % get SMI/BMI of specified layer
        [smi,bmi] = getIndex_reDefLayer_antpost(ABB,Layer{j},tpos);

        smi_pos = log2(smi.pos); % log transformation to make the distribution normal
        smi_ant = log2(smi.ant); % log transformation to make the distritubion normal
        bmi_pos = bmi.pos;
        bmi_ant = bmi.ant;
        n_tpos = length(tpos);
        
        % mean of the index...
        mSMI_pos = mean(smi_pos,1);
        mSMI_ant = mean(smi_ant,1);
        mBMI_pos = mean(bmi_pos,1);
        mBMI_ant = mean(bmi_ant,1);

        % standard error of the index...
        eSMI_pos = std(smi_pos,[],1) / sqrt(size(smi_pos,1));
        eSMI_ant = std(smi_ant,[],1) / sqrt(size(smi_ant,1));
        eBMI_pos = std(bmi_pos,[],1) / sqrt(size(bmi_pos,1));
        eBMI_ant = std(bmi_ant,[],1) / sqrt(size(bmi_ant,1));

        figure(1);
        subplot(2,2,pos(1)); hold on;
%         plot(1:n_tpos,mSMI_pos,'Color',color_core(j,:),'LineWidth',2);
%         plot(1:n_tpos,mSMI_ant,'Color',color_belt(j,:),'LineWidth',2);
        errorbar((1:n_tpos)+jitter(j),mSMI_pos,eSMI_pos,'Color',color_core(j,:),'LineWidth',1.5);
        errorbar((1:n_tpos)+jitter(j+2),mSMI_ant,eSMI_ant,'Color',color_belt(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Potision');
            ylabel(slabel);
            title(ABB);
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
        end

%         figure(2);
%         subplot(2,2,pos(1)); hold on;
% %         plot(1:n_tpos,mBMI_pos,'Color',color_core(j,:),'LineWidth',2);
% %         plot(1:n_tpos,mBMI_ant,'Color',color_belt(j,:),'LineWidth',2);
%         errorbar((1:n_tpos)+jitter(j),mBMI_pos,eBMI_pos,'Color',color_core(j,:),'LineWidth',1.5);
%         errorbar((1:n_tpos)+jitter(j+2),mBMI_ant,eBMI_ant,'Color',color_belt(j,:),'LineWidth',1.5);
%         if j==1
%             xlabel('Triplet Position');
%             ylabel('BMI');
%             title(ABB);
%             set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
%         end

        subplot(2,2,pos(2)); hold on;
        errorbar((1:n_tpos)+jitter(j),mSMI_pos,eSMI_pos,'Color',color_core(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Position');
            ylabel(slabel);
            title('Posterior');
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
        end

        subplot(2,2,pos(3)); hold on;
        errorbar((1:n_tpos)+jitter(j+2),mSMI_ant,eSMI_ant,'Color',color_belt(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Position');
            ylabel(slabel);
            title('Anterior');
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
        end
    end
end

% % add legends
% figure(1);
% if numel(Layer)==2
%     legend({'posterior superficial','anterior superficial','posterior deep','anterior deep'},'Location',[0.5 0.8 0.2 0.1]);
% elseif numel(Layer)==3
%     legend({'posterior superficial','anterior superficial','posterior granular','anterior granular','posterior deep','anterior deep'},'Location',[0.5 0.8 0.2 0.1]);
% end

figure(1);
subplot(2,2,pos(1));
if numel(Layer)==2
    legend({'posterior superficial','anterior superficial','poserior deep','anterior deep'},'Location',[0.5 0.8 0.2 0.1]);
elseif numel(Layer)==3
    legend({'poserior superficial','anterior superficial','posterior middle','anterior middle','posterior deep','anterior deep'},'Location',[0.5 0.8 0.2 0.1]);
end