% generete figure showing example MUA from CORE and BELT

% save_file_dir = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\MUA_Examples';
% save_file_dir = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\3_MUA_Examples\ver2';

% choose example from CORE
Animal = 'Cassius';
% RecDate = '20210111'; % core
RecDate = '20210331'; % belt
Channel = 23;
isSave = 0;
save_dir = fullfile(cd,'Belt');
% generate figure
% plot_ExampleMUA_v4(Animal,RecDate,Channel,'n'); % small and large stdiff only
% plot_ExampleMUA_v4_2(Animal,RecDate,Channel,'y'); % small and large stdiff only
plot_ExampleMUA_v4_2_gr(Animal,RecDate,Channel,'y'); % small and large stdiff only
% plot_ExampleMUA_v5(Animal,RecDate,Channel,'n'); % small and large stdiff only

if isSave==1
sName = strcat(Animal,'_',RecDate,'_ch',num2str(Channel));
saveas(gcf,fullfile(save_dir,sName),'png');
% exportgraphics(gcf,fullfile(save_file_dir,'ExampleMUA_CORE.eps'),'Resolution',600);
end

% % choose example from BELT
% Animal = 'Domo';
% RecDate = '20200110';
% Channel = 7;
% % generate figure
% % plot_ExampleMUA_v3(Animal,RecDate,Channel,'n'); % small and large stdiff only
% plot_ExampleMUA_v3_2(Animal,RecDate,Channel,'n'); % small and large stdiff only
% exportgraphics(gcf,fullfile(save_file_dir,'ExampleMUA_BELT1.eps'),'Resolution',600);
% 
% % choose another example (the one shows difference between hit and miss)...
% Animal = 'Cassius';
% RecDate = '20210220';
% Channel = 5;
% % plot_ExampleMUA_v3(Animal,RecDate,Channel,'y'); % small and large stdiff only
% plot_ExampleMUA_v3_2(Animal,RecDate,Channel,'y'); % small and large stdiff only
% exportgraphics(gcf,fullfile(save_file_dir,'ExampleMUA_BELT2.eps'),'Resolution',600);