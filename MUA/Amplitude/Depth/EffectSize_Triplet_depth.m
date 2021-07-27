clear all

% path for function calculating effect size...
addpath('C:\MatlabTools\measures-of-effect-size-toolbox');
addpath('../myFunction');

% DATA_PATH = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/';
DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response\Depth';
animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
layer = 'Deep'; % either 'Deep' or 'Sup'
auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
sTriplet = {'1st','2nd','3rd','Tm1','T'};

sigRESP_A = []; sigRESP_B1 = []; sigRESP_B2 = [];
for i = 1:length(sTriplet)
    fName = strcat(animal_name,'_zMUAResp_',sTriplet{i},'Triplet');
    load(fullfile(DATA_PATH,layer,fName));
    % concatenate data across triplet position
    % channel x easy-hard x hit-miss x session x triplet pos 
    sigRESP_A  = cat(5,sigRESP_A,sigRESP.A);
    sigRESP_B1 = cat(5,sigRESP_B1,sigRESP.B1);
    sigRESP_B2 = cat(5,sigRESP_B2,sigRESP.B2);
end

% choose sessions based on the recording sites...
j = 1:length(area_index);
if strcmp(auditory_area,'Core')
    j = j(area_index==1);
elseif strcmp(auditory_area,'Belt')
    j = j(area_index==0);
end
sigRESP_A  = sigRESP_A(:,:,:,j,:);
sigRESP_B1 = sigRESP_B1(:,:,:,j,:);
sigRESP_B2 = sigRESP_B2(:,:,:,j,:);

% % take average across conditions (need to modify later...)
% Reh_A = squeeze(mean(sigRESP_A,3)); 
% Rhm_A = squeeze(mean(sigRESP_A,2));
% 
% Reh_B1 = squeeze(mean(sigRESP_B1,3)); 
% Rhm_B1 = squeeze(mean(sigRESP_B1,2));
% 
% Reh_B2 = squeeze(mean(sigRESP_B2,3)); 
% Rhm_B2 = squeeze(mean(sigRESP_B2,2));

% plot
H(1) = subplot(2,2,1);
% plot_index_tpos(sigRESP_A);
HedgesG(1) = plot_EffectSize_tpos(sigRESP_A);
title('A');

H(2) = subplot(2,2,3);
% plot_index_tpos(sigRESP_B1);
HedgesG(2) = plot_EffectSize_tpos(sigRESP_B1);
title('B1');

H(3) = subplot(2,2,4);
% plot_index_tpos(sigRESP_B2);
HedgesG(3) = plot_EffectSize_tpos(sigRESP_B2);
title('B2');

for i=1:3
    y_range(i,:) = get(H(i),'YLim');
end
y_lim = [min(y_range(:,1)) max(y_range(:,2))];
set(H,'XTick',1:length(sTriplet),'XTickLabel',sTriplet,'XLim',[0.5 length(sTriplet)+0.5]);
set(H,'YLim',y_lim);
legend({'dF','Behavior'}, ...
    'Location',[0.53 0.72 0.1 0.2]);

% save effect size
save_file_name = strcat(animal_name,'_EffectSize_',auditory_area,'_',layer);
save( fullfile(DATA_PATH,save_file_name), 'HedgesG' );


%--
% sigRESP_area = sigRESP_A;
% hh = sigRESP_area(:,1,1,:,:); % hard-hit
% hm = sigRESP_area(:,1,2,:,:); % hard-miss
% eh = sigRESP_area(:,2,1,:,:); % easy-hit
% em = sigRESP_area(:,2,2,:,:); % eash-miss
% 
% size_reshape = [size(hh,1)*size(hh,4) size(hh,5)];
% hh = reshape(hh,size_reshape);
% hm = reshape(hm,size_reshape);
% eh = reshape(eh,size_reshape);
% em = reshape(em,size_reshape);
% 
% y = [ nanmean(hh,1); nanmean(hm,1); nanmean(eh,1); nanmean(em,1) ];
% n = [ sum(~isnan(hh),1); sum(~isnan(hm),1); sum(~isnan(eh),1); sum(~isnan(em),1) ];
% err  = [ nanstd(hh,0,1); nanstd(hm,0,1); nanstd(eh,0,1); nanstd(em,0,1) ];
% err2 = err ./ sqrt(n); % standard error
% 
% x = ones(4,1) * (1:size(y,2));
% jitter = [-0.03; -0.01; 0.01; 0.03] * ones(1,size(y,2));
% x = x + jitter;
% 
% h = errorbar(x',y',err2');
% set(h(1),'Marker','^','Color','r','LineWidth',1.5);
% set(h(2),'Marker','^','Color','b','LineStyle','--','LineWidth',1.5);
% set(h(3),'Marker','o','Color','r','LineWidth',1.5);
% set(h(4),'Marker','o','Color','b','LineStyle','--','LineWidth',1.5);