% obtain FMI SMI and BMI in specified triplet period (WITHOUT z-score)

clear all;
addpath ../

% ABB = {'A','B1','B2'};
% ABB = {'ABB'};
% Layer = {'S','I'}; 
Layer = {'S','G','I'};
% tpos = {'T-3','T-2','T-1','T'};
% tpos = {'T-1','T'};
tpos = {'T-1'};

% SET PARAMETERS!!
% % ver 1
% tp_fmi = [6]; % [T-1] triplet position
% tp_smi = [6]; % [T-1] triplet position
% tp_bmi = [7]; % [T] triplet position
% % ver 2
% tp_fmi = [1]; % [1st] triplet position
% tp_smi = [6]; % [T-1] triplet position
% tp_bmi = [7]; % [T] triplet position
% % ver 3
tp_fmi = [2]; % [2nd] triplet position
tp_smi = [2]; % [2nd] triplet position
tp_bmi = [7]; % [T] triplet position

isFigure = 1; % display figure (make sure to set tpos above...)
isSave = 1; % should choose 1 when saving data in mat file...
version = 3; % specify version number for saving data...

% line color
color_core = [157 195 230; 46 117 182; 31 78 121] / 255;
color_belt = [244 177 131; 197 90 17; 132 60 12] / 255;

% jitter in errorbar
% jitter = [-0.15 -0.05 0.05 0.15];
jitter = [-0.25 -0.15 -0.05 0.05 0.15 0.25];

pos = [1 3 4];
% figure;
for i=1 %1:length(ABB) % index for ABB triplet
    FMI_core = []; FMI_belt = [];
    SMI_core = []; SMI_belt = [];
    BMI_core = []; BMI_belt = [];
    for j=1:length(Layer) % index for layer
        % get SMI/BMI of specified layer
        [fmi,smi,bmi] = getIndex_layer_emergence_ABB_ver3(Layer{j});
        

        fmi_core = log2(fmi.core); % log transformation to make the distribution normal
        fmi_belt = log2(fmi.belt); % log transformation to make the distribution normal
        smi_core = log2(smi.core); % log transformation to make the distribution normal
        smi_belt = log2(smi.belt); % log transformation to make the distritubion normal
        bmi_core = bmi.core;
        bmi_belt = bmi.belt;
        n_tpos = length(tpos);

        % specify triplet period to get z-score...
        fmi_core = fmi_core(:,tp_fmi);
        fmi_belt = fmi_belt(:,tp_fmi);
        smi_core = smi_core(:,tp_smi);
        smi_belt = smi_belt(:,tp_smi);
        bmi_core = bmi_core(:,tp_bmi);
        bmi_belt = bmi_belt(:,tp_bmi);
        n_tpos_ori = size(smi_core,2); % must be the same for FMI, SMI, BMI
        
        N_core(j) = size(smi_core,1); % number of units in core
        N_belt(j) = size(smi_belt,1); % number of units in belt

        FMI_core = cat(1,FMI_core,fmi_core);
        FMI_belt = cat(1,FMI_belt,fmi_belt);
        SMI_core = cat(1,SMI_core,smi_core);
        SMI_belt = cat(1,SMI_belt,smi_belt);
        BMI_core = cat(1,BMI_core,bmi_core);
        BMI_belt = cat(1,BMI_belt,bmi_belt);
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
        nn_core = N_core(j);
        nn_belt = N_belt(j);
        
        fmi_core = FMI_core(1:nn_core,:);
        fmi_belt = FMI_belt(1:nn_belt,:);
        smi_core = SMI_core(1:nn_core,:);
        smi_belt = SMI_belt(1:nn_belt,:);
        bmi_core = BMI_core(1:nn_core,:);
        bmi_belt = BMI_belt(1:nn_belt,:);
        
        FMI_core(1:nn_core,:) = [];
        FMI_belt(1:nn_belt,:) = [];
        SMI_core(1:nn_core,:) = [];
        SMI_belt(1:nn_belt,:) = [];
        BMI_core(1:nn_core,:) = [];
        BMI_belt(1:nn_belt,:) = [];

        % combine data for saving...
        % area x layer x ABB
        FMI_LayerArea{1,j,i} = fmi_core;
        FMI_LayerArea{2,j,i} = fmi_belt;
        SMI_LayerArea{1,j,i} = smi_core;
        SMI_LayerArea{2,j,i} = smi_belt;
        BMI_LayerArea{1,j,i} = bmi_core;
        BMI_LayerArea{2,j,i} = bmi_belt;
        
        % mean of the index...
        mFMI_core = mean(fmi_core,1);
        mFMI_belt = mean(fmi_belt,1);
        mSMI_core = mean(smi_core,1);
        mSMI_belt = mean(smi_belt,1);
        mBMI_core = mean(bmi_core,1);
        mBMI_belt = mean(bmi_belt,1);

        % standard error of the index...
        eFMI_core = std(fmi_core,[],1) / sqrt(size(fmi_core,1));
        eFMI_belt = std(fmi_belt,[],1) / sqrt(size(fmi_belt,1));
        eSMI_core = std(smi_core,[],1) / sqrt(size(smi_core,1));
        eSMI_belt = std(smi_belt,[],1) / sqrt(size(smi_belt,1));
        eBMI_core = std(bmi_core,[],1) / sqrt(size(bmi_core,1));
        eBMI_belt = std(bmi_belt,[],1) / sqrt(size(bmi_belt,1));
        
    if isFigure
        figure(1);
        subplot(2,2,pos(i)); hold on;
        % choose T-3 to T triplet just for display
%         mSMI_core = mSMI_core(:,4:7); eSMI_core = eSMI_core(:,4:7);
%         mSMI_belt = mSMI_belt(:,4:7); eSMI_belt = eSMI_belt(:,4:7);
        errorbar((1:n_tpos)+jitter(j),mFMI_core,eFMI_core,'Color',color_core(j,:),'LineWidth',1.5);
        errorbar((1:n_tpos)+jitter(j+2),mFMI_belt,eFMI_belt,'Color',color_belt(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Potision');
            ylabel('zFMI');
            title('BB');
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
        end

        figure(2);
        subplot(2,2,pos(i)); hold on;
        % choose T-3 to T triplet just for display
%         mSMI_core = mSMI_core(:,4:7); eSMI_core = eSMI_core(:,4:7);
%         mSMI_belt = mSMI_belt(:,4:7); eSMI_belt = eSMI_belt(:,4:7);
        errorbar((1:n_tpos)+jitter(j),mSMI_core,eSMI_core,'Color',color_core(j,:),'LineWidth',1.5);
        errorbar((1:n_tpos)+jitter(j+2),mSMI_belt,eSMI_belt,'Color',color_belt(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Potision');
            ylabel('zSMI');
            title('A');
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
        end

        figure(3);
        subplot(2,2,pos(i)); hold on;
        % choose T-3 to T triplet just for display
%         mBMI_core = mBMI_core(:,4:7); eBMI_core = eBMI_core(:,4:7);
%         mBMI_belt = mBMI_belt(:,4:7); eBMI_belt = eBMI_belt(:,4:7);
        errorbar((1:n_tpos)+jitter(j),mBMI_core,eBMI_core,'Color',color_core(j,:),'LineWidth',1.5);
        errorbar((1:n_tpos)+jitter(j+2),mBMI_belt,eBMI_belt,'Color',color_belt(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Position');
            ylabel('zBMI');
            title('ABB');
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
        end
        clear z_fmi_core z_fmi_belt z_smi_core z_smi_belt z_bmi_core z_bmi_belt
    end
    end
end

if isFigure
% add legends
figure(1);
% legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
legend({'core superficial','belt superficial','core granular','belt granular','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
figure(2);
% legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
legend({'core superficial','belt superficial','core granular','belt granular','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
figure(3);
% legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
legend({'core superficial','belt superficial','core granular','belt granular','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
end

sTriplet = {'1st','2nd','3rd','T-3','T-2','T-1','T'};
sTriplet_fmi = sTriplet(tp_fmi);
sTriplet_smi = sTriplet(tp_smi);
sTriplet_bmi = sTriplet(tp_bmi);
% save
if isSave==1
    % SMI is already log transformed!!
    if version==1
        save_file_name = 'FMISMIBMI_LayerArea_ABB_ver3';
    else
        save_file_name = strcat('FMISMIBMI_LayerArea_ABB_ver3_',num2str(version));
    end
    save(save_file_name,'FMI_LayerArea','SMI_LayerArea','BMI_LayerArea','sTriplet_fmi','sTriplet_smi','sTriplet_bmi');
end