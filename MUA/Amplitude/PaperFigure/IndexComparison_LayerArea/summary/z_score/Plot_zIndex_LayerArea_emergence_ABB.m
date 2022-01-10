% plot and save z-scored SMI and BMI
clear all;
addpath ../

% ABB = {'A','B1','B2'};
ABB = {'ABB'};
% Layer = {'S','I'}; 
Layer = {'S','G','I'};
tpos = {'T-3','T-2','T-1','T'};
isSave = 0; % should choose 1 when saving data in mat file...

% line color
color_core = [157 195 230; 46 117 182; 31 78 121] / 255;
color_belt = [244 177 131; 197 90 17; 132 60 12] / 255;

% jitter in errorbar
% jitter = [-0.15 -0.05 0.05 0.15];
jitter = [-0.25 -0.15 -0.05 0.05 0.15 0.25];

pos = [1 3 4];
% figure;
for i=1:length(ABB) % index for ABB triplet
    SMI_core = []; SMI_belt = [];
    BMI_core = []; BMI_belt = [];
    for j=1:length(Layer) % index for layer
        % get SMI/BMI of specified layer
        [smi,bmi] = getIndex_layer_emergence_ABB(ABB{i},Layer{j});

        smi_core = log2(smi.core); % log transformation to make the distribution normal
        smi_belt = log2(smi.belt); % log transformation to make the distritubion normal
        bmi_core = bmi.core;
        bmi_belt = bmi.belt;
        n_tpos = length(tpos);
        n_tpos_ori = size(smi_core,2);
        
        N_core(j) = size(smi_core,1); % number of units in core
        N_belt(j) = size(smi_belt,1); % number of units in belt

        SMI_core = cat(1,SMI_core,smi_core);
        SMI_belt = cat(1,SMI_belt,smi_belt);
        BMI_core = cat(1,BMI_core,bmi_core);
        BMI_belt = cat(1,BMI_belt,bmi_belt);
    end
    % take z-score...
    zSMI_core = zscore(SMI_core(:));
    zSMI_belt = zscore(SMI_belt(:));
    zBMI_core = zscore(BMI_core(:));
    zBMI_belt = zscore(BMI_belt(:));

    % reshape z-scored vector into matrix of original size...
    zSMI_core = reshape(zSMI_core,sum(N_core),n_tpos_ori);
    zSMI_belt = reshape(zSMI_belt,sum(N_belt),n_tpos_ori);
    zBMI_core = reshape(zBMI_core,sum(N_core),n_tpos_ori);
    zBMI_belt = reshape(zBMI_belt,sum(N_belt),n_tpos_ori);
    
    % separate data into layer
    for j=1:length(Layer)
        nn_core = N_core(j);
        nn_belt = N_belt(j);

        z_smi_core = zSMI_core(1:nn_core,:);
        z_smi_belt = zSMI_belt(1:nn_belt,:);
        z_bmi_core = zBMI_core(1:nn_core,:);
        z_bmi_belt = zBMI_belt(1:nn_belt,:);

        zSMI_core(1:nn_core,:) = [];
        zSMI_belt(1:nn_belt,:) = [];
        zBMI_core(1:nn_core,:) = [];
        zBMI_belt(1:nn_belt,:) = [];

        % combine data for saving...
        % area x layer x ABB
        zSMI_LayerArea{1,j,i} = z_smi_core;
        zSMI_LayerArea{2,j,i} = z_smi_belt;
        zBMI_LayerArea{1,j,i} = z_bmi_core;
        zBMI_LayerArea{2,j,i} = z_bmi_belt;
        
        % mean of the index...
        mSMI_core = mean(z_smi_core,1);
        mSMI_belt = mean(z_smi_belt,1);
        mBMI_core = mean(z_bmi_core,1);
        mBMI_belt = mean(z_bmi_belt,1);

        % standard error of the index...
        eSMI_core = std(z_smi_core,[],1) / sqrt(size(z_smi_core,1));
        eSMI_belt = std(z_smi_belt,[],1) / sqrt(size(z_smi_belt,1));
        eBMI_core = std(z_bmi_core,[],1) / sqrt(size(z_bmi_core,1));
        eBMI_belt = std(z_bmi_belt,[],1) / sqrt(size(z_bmi_belt,1));
        

        figure(1);
        subplot(2,2,pos(i)); hold on;
        % choose T-3 to T triplet just for display
        mSMI_core = mSMI_core(:,4:7); eSMI_core = eSMI_core(:,4:7);
        mSMI_belt = mSMI_belt(:,4:7); eSMI_belt = eSMI_belt(:,4:7);
        errorbar((1:n_tpos)+jitter(j),mSMI_core,eSMI_core,'Color',color_core(j,:),'LineWidth',1.5);
        errorbar((1:n_tpos)+jitter(j+2),mSMI_belt,eSMI_belt,'Color',color_belt(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Potision');
            ylabel('zSMI');
            title(ABB{i});
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
        end

        figure(2);
        subplot(2,2,pos(i)); hold on;
        % choose T-3 to T triplet just for display
        mBMI_core = mBMI_core(:,4:7); eBMI_core = eBMI_core(:,4:7);
        mBMI_belt = mBMI_belt(:,4:7); eBMI_belt = eBMI_belt(:,4:7);
        errorbar((1:n_tpos)+jitter(j),mBMI_core,eBMI_core,'Color',color_core(j,:),'LineWidth',1.5);
        errorbar((1:n_tpos)+jitter(j+2),mBMI_belt,eBMI_belt,'Color',color_belt(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Position');
            ylabel('zBMI');
            title(ABB{i});
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
        end
        clear z_smi_core z_smi_belt z_bmi_core z_bmi_belt
    end
end

% add legends
figure(1);
% legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
legend({'core superficial','belt superficial','core granular','belt granular','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
figure(2);
% legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
legend({'core superficial','belt superficial','core granular','belt granular','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);

sTriplet = {'1st','2nd','3rd','T-3','T-2','T-1','T'};
% save
if isSave==1
    % SMI is already log transformed!!
    save_file_name = 'zSMIBMI_LayerArea_ABB';
    save(save_file_name,'zSMI_LayerArea','zBMI_LayerArea','sTriplet');
end