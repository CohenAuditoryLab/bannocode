clear all;

ABB = {'A','B1','B2'};
% Layer = {'S','I'}; 
Layer = {'S','G','I'};
tpos = {'1st','2nd','3rd','T-1','T'};

% line color
color_core = [157 195 230; 46 117 182; 31 78 121] / 255;
color_belt = [244 177 131; 197 90 17; 132 60 12] / 255;

% jitter in errorbar
% jitter = [-0.15 -0.05 0.05 0.15];
jitter = [-0.25 -0.15 -0.05 0.05 0.15 0.25];

pos = [1 3 4];
% figure;
for i=1:length(ABB) % index for ABB triplet
    for j=1:length(Layer) % index for layer
        % get SMI/BMI of specified layer
        [smi,bmi] = getIndex_layer_ver2(ABB{i},Layer{j});

        smi_core = log2(smi.core); % log transformation to make the distribution normal
        smi_belt = log2(smi.belt); % log transformation to make the distritubion normal
        bmi_core = bmi.core;
        bmi_belt = bmi.belt;
        n_tpos = length(tpos);
        
        % mean of the index...
        mSMI_core = mean(smi_core,1);
        mSMI_belt = mean(smi_belt,1);
        mBMI_core = mean(bmi_core,1);
        mBMI_belt = mean(bmi_belt,1);

        % standard error of the index...
        eSMI_core = std(smi_core,[],1) / sqrt(size(smi_core,1));
        eSMI_belt = std(smi_belt,[],1) / sqrt(size(smi_belt,1));
        eBMI_core = std(bmi_core,[],1) / sqrt(size(bmi_core,1));
        eBMI_belt = std(bmi_belt,[],1) / sqrt(size(bmi_belt,1));

        % combine data for saving...
        % area x layer x ABB
        SMI_LayerArea{1,j,i} = smi_core;
        SMI_LayerArea{2,j,i} = smi_belt;
        BMI_LayerArea{1,j,i} = bmi_core;
        BMI_LayerArea{2,j,i} = bmi_belt;

        figure(1);
        subplot(2,2,pos(i)); hold on;
%         plot(1:n_tpos,mSMI_core,'Color',color_core(j,:),'LineWidth',2);
%         plot(1:n_tpos,mSMI_belt,'Color',color_belt(j,:),'LineWidth',2);
        errorbar((1:n_tpos)+jitter(j),mSMI_core,eSMI_core,'Color',color_core(j,:),'LineWidth',1.5);
        errorbar((1:n_tpos)+jitter(j+2),mSMI_belt,eSMI_belt,'Color',color_belt(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Potision');
            ylabel('log(SMI)');
            title(ABB{i});
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
        end

        figure(2);
        subplot(2,2,pos(i)); hold on;
%         plot(1:n_tpos,mBMI_core,'Color',color_core(j,:),'LineWidth',2);
%         plot(1:n_tpos,mBMI_belt,'Color',color_belt(j,:),'LineWidth',2);
        errorbar((1:n_tpos)+jitter(j),mBMI_core,eBMI_core,'Color',color_core(j,:),'LineWidth',1.5);
        errorbar((1:n_tpos)+jitter(j+2),mBMI_belt,eBMI_belt,'Color',color_belt(j,:),'LineWidth',1.5);
        if j==1
            xlabel('Triplet Position');
            ylabel('BMI');
            title(ABB{i});
            set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
        end
    end
end

% add legends
figure(1);
% legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
legend({'core superficial','belt superficial','core granular','belt granular','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
figure(2);
% legend({'core superficial','belt superficial','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);
legend({'core superficial','belt superficial','core granular','belt granular','core deep','belt deep'},'Location',[0.5 0.8 0.2 0.1]);

% save
% SMI is already log transformed!!
save_file_name = 'SMIBMI_LayerArea';
save(save_file_name,'SMI_LayerArea','BMI_LayerArea');