clear all

% set variables
isSave = 1; % 0 - not save figure, 1 - save figure...
type = 'Selectivity'; %'TvsNT'; % 'Adaptation';
cRange = [0 16]; % 16ch electrode

% fixed variables
save_file_name = strcat(type,'_Domo_All');
save_file_dir = fullfile('across_sessions_triplet',type);
c = [0 0.4470 0.7410; 0.850 0.325 0.098]; % face color of bar graph
s = {'HIT','MISS'}; % label for the bar graph
% list_st_all = [1 2 4 8 10 16 24];

% list all sessions from Domo
list_session = {'20180709','20180727','20180807','20180907','20181210', ...
    '20181212','20190123','20190409','20190821','20190828','20191009', ...
    '20191210','20191220','20200103','20200110','20200114'};

if strcmp(type,'Selectivity')
%     dPrime_A = []; dPrime_B = [];
%     dPrime_H = []; dPrime_M = []; % used and saved only in 'Selectivity'
    dPrime_B1 = []; dPrime_B2 = [];
    prefA.B1 = []; prefA.B2 = [];
    prefB.B1 = []; prefB.B2 = [];
elseif strcmp(type,'Adaptation')
    dPrime_A = []; dPrime_B1 = []; dPrime_B2 = [];
    prefA.A = []; prefA.B1 = []; prefA.B2 = [];
    prefB.A = []; prefB.B1 = []; prefB.B2 = [];
end

for ff=1:numel(list_session)
    rec_date = list_session{ff};
%     [dp,~] = calcAdaptation_triplet(rec_date,cRange,isSave); % adaptation
%     [dp,~] = calcTvsNT_triplet(rec_date,isSave); % target vs non-target
    [dp,~] = calcSelectivity_triplet(rec_date,cRange,isSave); % selectivity change
    if strcmp(type,'Selectivity')
%         dPrime_A = cat(3,dPrime_A,dp.A);
%         dPrime_B = cat(3,dPrime_B,dp.B);
%         dPrime_H = cat(2,dPrime_H,dp.H);
%         dPrime_M = cat(2,dPrime_M,dp.M);
        dPrime_B1 = cat(4,dPrime_B1,dp.B1);
        dPrime_B2 = cat(4,dPrime_B2,dp.B2);
        prefA.B1 = cat(2,prefA.B1,dp.prefA.B1);
        prefA.B2 = cat(2,prefA.B2,dp.prefA.B2);
        prefB.B1 = cat(2,prefB.B1,dp.prefB.B1);
        prefB.B2 = cat(2,prefB.B2,dp.prefB.B2);
    elseif strcmp(type,'Adaptation')
        dPrime_A  = cat(4,dPrime_A,dp.A);
        dPrime_B1 = cat(4,dPrime_B1,dp.B1);
        dPrime_B2 = cat(4,dPrime_B2,dp.B2);
        prefA.A  = cat(2,prefA.A,dp.prefA.A);
        prefA.B1 = cat(2,prefA.B1,dp.prefA.B1);
        prefA.B2 = cat(2,prefA.B2,dp.prefA.B2);
        prefB.A  = cat(2,prefB.A,dp.prefB.A);
        prefB.B1 = cat(2,prefB.B1,dp.prefB.B1);
        prefB.B2 = cat(2,prefB.B2,dp.prefB.B2);
    end
    clear rec_date
    close all
end

if strcmp(type,'Selectivity')
%     save(fullfile(save_file_dir,save_file_name),'dPrime_A','dPrime_B','dPrime_H','dPrime_M');
    save(fullfile(save_file_dir,save_file_name),'dPrime_B1','dPrime_B2','prefA','prefB');
elseif strcmp(type,'Adaptation')
    save(fullfile(save_file_dir,save_file_name),'dPrime_A','dPrime_B1','dPrime_B2','prefA','prefB');
end


% if strcmp(type,'Selectivity')==0
% dpa_mean = nanmean(dPrime_A,2);
% dpb_mean = nanmean(dPrime_B,2);
% % dpa_std = nanstd(dPrime_A,0,2);
% % dpb_std = nanstd(dPrime_B,0,2);
% dpa_sem = nanstd(dPrime_A,0,2) / sqrt(size(dPrime_A,2));
% dpb_sem = nanstd(dPrime_B,0,2) / sqrt(size(dPrime_B,2));
% 
% data_y = [dpa_mean dpb_mean];
% error_y = [dpa_sem dpb_sem];
% [ngroups,nbars] = size(data_y);
% groupwidth = min(0.8, nbars/(nbars + 1.5));
% h = bar([dpa_mean dpb_mean]); hold on
% for i = 1:nbars
%     x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%     errorbar(x, data_y(:,i), error_y(:,i), 'k', 'linestyle', 'none');
% end
% h(1).FaceColor = c(1,:);
% h(2).FaceColor = c(2,:);
% set(gca,'XTickLabel',s);
% ylabel('d prime');
% legend({'tone A','tone B'},'Location',[0.65 0.15 0.2 0.1]);
% title(strcat(type,' Domo'));
% 
% end
