% obtain FMI SMI and BMI in specified triplet period (WITHOUT z-score)

clear all;
% addpath('C:\Users\Taku\Documents\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\code\Amplitude\PaperFigure\IndexComparison_LayerArea\summary\z_score\new_Index');
% addpath ../

Layer = {'S','G','I'};
tpos = {'1st','2nd','3rd','T-3','T-2','T-1','Target','T+1'};

% SET PARAMETERS!!
% % ver 1
% tp_fmi = [6]; % [T-1] triplet position
% tp_smi = [6]; % [T-1] triplet position
% tp_bmi = [7]; % [T] triplet position
% % ver 2
% tp_fmi = [6]; % [T-1] triplet position
% tp_smi = [6]; % [T-1] triplet position
% tp_bmi = [1]; % [1st] triplet position
% ver 3; 1st (1), T-1 (6), T (7) or T+1 (7) triplet position for all index
tp_fmi = [8]; % [T] triplet position
tp_smi = [8]; % [T] triplet position
tp_bmi = [8]; % [T] triplet position

isFigure = 1; % display figure (make sure to set tpos above...)
isSave = 1; % should choose 1 when saving data in mat file...
version = 3; % specify version number for saving data...

% line color
color_post = [157 195 230; 46 117 182; 31 78 121] / 255;
color_ant  = [244 177 131; 197 90 17; 132 60 12] / 255;

% jitter in errorbar
% jitter = [-0.15 -0.05 0.05 0.15];
jitter = [-0.25 -0.15 -0.05 0.05 0.15 0.25];

pos = [1 3 4];
% figure;
for i=1 %1:length(ABB) % index for ABB triplet
    FMI_post = []; FMI_ant  = [];
    SMI_post = []; SMI_ant  = [];
    BMI_post = []; BMI_ant  = [];
    for j=1:length(Layer) % index for layer
        % get SMI/BMI of specified layer
        [fmi,smi,bmi] = getIndex_reDefLayer_emergence_ABB_CoreBelt_PostAnt(Layer{j});

        fmi_post = log2(fmi.post); % log transformation to make the distribution normal
        fmi_ant  = log2(fmi.ant); % log transformation to make the distribution normal
        smi_post = log2(smi.post); % log transformation to make the distribution normal
        smi_ant  = log2(smi.ant); % log transformation to make the distritubion normal
        bmi_post = bmi.post;
        bmi_ant  = bmi.ant;

        n_tpos = 1; %length(tpos);

        % specify triplet period to get z-score...
        fmi_post = fmi_post(:,tp_fmi);
        fmi_ant  = fmi_ant(:,tp_fmi);
        smi_post = smi_post(:,tp_smi);
        smi_ant  = smi_ant(:,tp_smi);
        bmi_post = bmi_post(:,tp_bmi);
        bmi_ant  = bmi_ant(:,tp_bmi);

        n_tpos_ori = size(smi_post,2); % must be the same for FMI, SMI, BMI
        
        N_post(j) = size(smi_post,1); % number of units in posterior
        N_ant(j)  = size(smi_ant,1);  % number of units in anterior

        FMI_post = cat(1,FMI_post,fmi_post);
        FMI_ant  = cat(1,FMI_ant,fmi_ant);
        SMI_post = cat(1,SMI_post,smi_post);
        SMI_ant  = cat(1,SMI_ant,smi_ant);
        BMI_post = cat(1,BMI_post,bmi_post);
        BMI_ant  = cat(1,BMI_ant,bmi_ant);

    end

%     % take z-score...
%     zFMI_core = zscore(FMI_core(:));
%     zFMI_belt = zscore(FMI_belt(:));
%     zSMI_core = zscore(SMI_core(:));
%     zSMI_belt = zscore(SMI_belt(:));
%     zBMI_core = zscore(BMI_core(:));
%     zBMI_belt = zscore(BMI_belt(:));
% 
%     % reshape z-scored vector into matrix of original size...
%     zFMI_core = reshape(zFMI_core,sum(N_core),n_tpos_ori);
%     zFMI_belt = reshape(zFMI_belt,sum(N_belt),n_tpos_ori);
%     zSMI_core = reshape(zSMI_core,sum(N_core),n_tpos_ori);
%     zSMI_belt = reshape(zSMI_belt,sum(N_belt),n_tpos_ori);
%     zBMI_core = reshape(zBMI_core,sum(N_core),n_tpos_ori);
%     zBMI_belt = reshape(zBMI_belt,sum(N_belt),n_tpos_ori);
    
    % separate data into layer
    for j=1:length(Layer)
        nn_post = N_post(j);
        nn_ant  = N_ant(j);

        fmi_post = FMI_post(1:nn_post,:);
        fmi_ant  = FMI_ant(1:nn_ant,:);
        smi_post = SMI_post(1:nn_post,:);
        smi_ant  = SMI_ant(1:nn_ant,:);
        bmi_post = BMI_post(1:nn_post,:);
        bmi_ant = BMI_ant(1:nn_ant,:);

        FMI_post(1:nn_post,:) = [];
        FMI_ant(1:nn_ant,:) = [];
        SMI_post(1:nn_post,:) = [];
        SMI_ant(1:nn_ant,:) = [];
        BMI_post(1:nn_post,:) = [];
        BMI_ant(1:nn_ant,:) = [];  

        % combine data for saving...
        % area x layer x ABB
        FMI_LayerArea{1,j,i} = fmi_post;
        FMI_LayerArea{2,j,i} = fmi_ant;
        SMI_LayerArea{1,j,i} = smi_post;
        SMI_LayerArea{2,j,i} = smi_ant;
        BMI_LayerArea{1,j,i} = bmi_post;
        BMI_LayerArea{2,j,i} = bmi_ant;
        
        % mean of the index...
        mFMI_post = mean(fmi_post,1);
        mFMI_ant  = mean(fmi_ant,1);
        mSMI_post = mean(smi_post,1);
        mSMI_ant  = mean(smi_ant,1);
        mBMI_post = mean(bmi_post,1);
        mBMI_ant  = mean(bmi_ant,1);

        % standard error of the index...
        eFMI_post = std(fmi_post,[],1) / sqrt(size(fmi_post,1));
        eFMI_ant  = std(fmi_ant,[],1) / sqrt(size(fmi_ant,1));
        eSMI_post = std(smi_post,[],1) / sqrt(size(smi_post,1));
        eSMI_ant  = std(smi_ant,[],1) / sqrt(size(smi_ant,1));
        eBMI_post = std(bmi_post,[],1) / sqrt(size(bmi_post,1));
        eBMI_ant  = std(bmi_ant,[],1) / sqrt(size(bmi_ant,1));
        
    if isFigure
        figure(1);
        subplot(2,2,pos(i)); hold on;
        % choose T-3 to T triplet just for display
%         mSMI_core = mSMI_core(:,4:7); eSMI_core = eSMI_core(:,4:7);
%         mSMI_belt = mSMI_belt(:,4:7); eSMI_belt = eSMI_belt(:,4:7);
        errorbar((1:n_tpos)+jitter(j),mFMI_post,eFMI_post,'Color',color_post(j,:),'LineWidth',1.5);
        errorbar((1:n_tpos)+jitter(j+2),mFMI_ant,eFMI_ant,'Color',color_ant(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Potision');
            ylabel('zFMI');
            title('BB');
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos{tp_fmi},'XLim',[0.5 n_tpos+0.5]);
        end

        figure(2);
        subplot(2,2,pos(i)); hold on;
        % choose T-3 to T triplet just for display
%         mSMI_core = mSMI_core(:,4:7); eSMI_core = eSMI_core(:,4:7);
%         mSMI_belt = mSMI_belt(:,4:7); eSMI_belt = eSMI_belt(:,4:7);
        errorbar((1:n_tpos)+jitter(j),mSMI_post,eSMI_post,'Color',color_post(j,:),'LineWidth',1.5);
        errorbar((1:n_tpos)+jitter(j+2),mSMI_ant,eSMI_ant,'Color',color_ant(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Potision');
            ylabel('zSMI');
            title('A');
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos{tp_smi},'XLim',[0.5 n_tpos+0.5]);
        end

        figure(3);
        subplot(2,2,pos(i)); hold on;
        % choose T-3 to T triplet just for display
%         mBMI_core = mBMI_core(:,4:7); eBMI_core = eBMI_core(:,4:7);
%         mBMI_belt = mBMI_belt(:,4:7); eBMI_belt = eBMI_belt(:,4:7);
        errorbar((1:n_tpos)+jitter(j),mBMI_post,eBMI_post,'Color',color_post(j,:),'LineWidth',1.5);
        errorbar((1:n_tpos)+jitter(j+2),mBMI_ant,eBMI_ant,'Color',color_ant(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Position');
            ylabel('zBMI');
            title('ABB');
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos{tp_bmi},'XLim',[0.5 n_tpos+0.5]);
        end
        clear z_fmi_core z_fmi_belt z_smi_core z_smi_belt z_bmi_core z_bmi_belt
    end
    end
end

if isFigure
% add legends
figure(1);
% legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
legend({'posterior superficial','anterior superficial','posterior granular','anterior granular','posterior deep','anterior deep'},'Location',[0.5 0.8 0.2 0.1]);
figure(2);
% legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
legend({'posterior superficial','anterior superficial','posterior granular','anterior granular','posterior deep','anterior deep'},'Location',[0.5 0.8 0.2 0.1]);
figure(3);
% legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
legend({'posterior superficial','anterior superficial','posterior granular','anterior granular','posterior deep','anterior deep'},'Location',[0.5 0.8 0.2 0.1]);
end

sTriplet = {'1st','2nd','3rd','T-3','T-2','T-1','T','T+1'};
sTriplet_fmi = sTriplet(tp_fmi);
sTriplet_smi = sTriplet(tp_smi);
sTriplet_bmi = sTriplet(tp_bmi);
% save
if isSave==1
    % SMI is already log transformed!!
    if version==1
        save_file_name = 'FMISMIBMI_LayerArea_ABB_PostAnt';
    else
        save_file_name = strcat('FMISMIBMI_LayerArea_ABB_PostAnt_',num2str(version));
    end
    save(save_file_name,'FMI_LayerArea','SMI_LayerArea','BMI_LayerArea','sTriplet_fmi','sTriplet_smi','sTriplet_bmi');
end