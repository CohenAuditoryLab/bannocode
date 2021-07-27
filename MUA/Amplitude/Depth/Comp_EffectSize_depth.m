clear all

% path for function calculating effect size...
% addpath('C:\MatlabTools\measures-of-effect-size-toolbox');
addpath('../myFunction');

% DATA_PATH = '/Volumes/TOSHIBA_EXT/01_STREAMING/MUA/Results/AcrossSessions/Response/';
DATA_PATH = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\MUA\Results\AcrossSessions\Response\Depth';
animal_name = 'Both'; % either 'Domo', 'Cassius', or 'Both'
layer = {'Sup','Deep'}; % either 'Deep' or 'Sup'
auditory_area = 'All'; % either 'Core', 'Belt', or 'All'
sTriplet = {'1st','2nd','3rd','Tm1','T'};

fName_root = strcat(animal_name,'_EffectSize_',auditory_area,'_');
fName = strcat(fName_root,'Sup');
sup = load(fullfile(DATA_PATH,fName));
fName = strcat(fName_root,'Deep');
deep = load(fullfile(DATA_PATH,fName));

sup_A   = sup.HedgesG(1);
deep_A  = deep.HedgesG(1);
sup_B1  = sup.HedgesG(2);
deep_B1 = deep.HedgesG(2);
sup_B2  = sup.HedgesG(3);
deep_B2 = deep.HedgesG(3);

% sigRESP_A = []; sigRESP_B1 = []; sigRESP_B2 = [];
% for i = 1:length(sTriplet)
%     fName = strcat(animal_name,'_zMUAResp_',sTriplet{i},'Triplet');
%     load(fullfile(DATA_PATH,layer,fName));
%     % concatenate data across triplet position
%     % channel x easy-hard x hit-miss x session x triplet pos 
%     sigRESP_A  = cat(5,sigRESP_A,sigRESP.A);
%     sigRESP_B1 = cat(5,sigRESP_B1,sigRESP.B1);
%     sigRESP_B2 = cat(5,sigRESP_B2,sigRESP.B2);
% end
% 
% % choose sessions based on the recording sites...
% j = 1:length(area_index);
% if strcmp(auditory_area,'Core')
%     j = j(area_index==1);
% elseif strcmp(auditory_area,'Belt')
%     j = j(area_index==0);
% end
% sigRESP_A  = sigRESP_A(:,:,:,j,:);
% sigRESP_B1 = sigRESP_B1(:,:,:,j,:);
% sigRESP_B2 = sigRESP_B2(:,:,:,j,:);


% plot
plot_EffectSize_depth(sup_A,deep_A);

% % plot
% H(1) = subplot(2,2,1);
% % plot_index_tpos(sigRESP_A);
% plot_EffectSize_tpos(sigRESP_A);
% title('A');
% 
% H(2) = subplot(2,2,3);
% % plot_index_tpos(sigRESP_B1);
% plot_EffectSize_tpos(sigRESP_B1);
% title('B1');
% 
% H(3) = subplot(2,2,4);
% % plot_index_tpos(sigRESP_B2);
% plot_EffectSize_tpos(sigRESP_B2);
% title('B2');
% 
% for i=1:3
%     y_range(i,:) = get(H(i),'YLim');
% end
% y_lim = [min(y_range(:,1)) max(y_range(:,2))];
% set(H,'XTick',1:length(sTriplet),'XTickLabel',sTriplet,'XLim',[0.5 length(sTriplet)+0.5]);
% set(H,'YLim',y_lim);
% legend({'dF','Behavior'}, ...
%     'Location',[0.53 0.72 0.1 0.2]);
