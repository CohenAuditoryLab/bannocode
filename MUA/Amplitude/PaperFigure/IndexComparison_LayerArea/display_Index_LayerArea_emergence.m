function [index] = display_Index_LayerArea_emergence(index_core,index_belt,Type)
% plot SMI and BMI of layer/area in the same graph

dSup_core  = removeNaN_fromMat(index_core.s);
dDeep_core = removeNaN_fromMat(index_core.d);
dSup_belt  = removeNaN_fromMat(index_belt.s);
dDeep_belt = removeNaN_fromMat(index_belt.d);

if strcmp(Type,'Stim')
    dSup_core  = log2(dSup_core);
    dDeep_core = log2(dDeep_core);
    dSup_belt  = log2(dSup_belt);
    dDeep_belt = log2(dDeep_belt);
    y_label = 'log(SMI)';
elseif strcmp(Type,'Behav')
    y_label = 'BMI';
end

tpos = {'T-3','T-2','T-1','T'}; n_tpos = length(tpos);
jitter = [-0.12 -0.04 0.04 0.12];
% line color
color_core = [157 195 230; 46 117 182; 31 78 121] / 255;
color_belt = [244 177 131; 197 90 17; 132 60 12] / 255;

% mean of the index...
mSup_core = mean(dSup_core,1);
mDeep_core = mean(dDeep_core,1);
mSup_belt = mean(dSup_belt,1);
mDeep_belt = mean(dDeep_belt,1);

% standard error of index...
eSup_core  = std(dSup_core,[],1) / sqrt(size(dSup_core,1)) ;
eDeep_core = std(dDeep_core,[],1) / sqrt(size(dDeep_core,1));
eSup_belt  = std(dSup_belt,[],1) / sqrt(size(dSup_belt,1));
eDeep_belt = std(dDeep_belt,[],1) / sqrt(size(dDeep_belt,1));

% plot index
errorbar((1:n_tpos)+jitter(1),mSup_core,eSup_core,'Color',color_core(1,:),'LineWidth',1.5); hold on;
errorbar((1:n_tpos)+jitter(2),mSup_belt,eSup_belt,'Color',color_belt(1,:),'LineWidth',1.5);
errorbar((1:n_tpos)+jitter(3),mDeep_core,eDeep_core,'Color',color_core(3,:),'LineWidth',1.5);
errorbar((1:n_tpos)+jitter(4),mDeep_belt,eDeep_belt,'Color',color_belt(3,:),'LineWidth',1.5);
xlabel('Triplet Position'); ylabel(y_label);
set(gca,'XTick',1:n_tpos,'XTickLabel',tpos,'XLim',[0.5 n_tpos+0.5]);
box off;

index.sup.core  = dSup_core;
index.sup.belt  = dSup_belt;
index.deep.core = dDeep_core;
index.deep.belt = dDeep_belt;

end