% generete figure showing example MUA from CORE and BELT

addpath('Check_MUA');
% save_file_dir = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\MUA_Examples';
% save_file_dir = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\3_MUA_Examples\ver2';
save_file_dir = 'C:\Users\Taku\Documents\03_Research_Paper\Streaming\Figures\Finalize\3_MUA_Examples\ver3\redblue';

% choose example from CORE
Animal = 'Domo';
RecDate = '20180709';
Channel = 9;
% generate figure
% plot_ExampleMUA_v3(Animal,RecDate,Channel,'n'); % small and large stdiff only
% plot_ExampleMUA_v3_2(Animal,RecDate,Channel,'n'); % small and large stdiff only
% plot_ExampleMUA_v4_2(Animal,RecDate,Channel,'n'); % smoothed
plot_ExampleMUA_v4_2_gr(Animal,RecDate,Channel,'n'); % gray scale
exportgraphics(gcf,fullfile(save_file_dir,'ExampleMUA_CORE.eps'),'Resolution',600);

% choose example from BELT
Animal = 'Domo';
RecDate = '20200110';
Channel = 7;
% generate figure
% plot_ExampleMUA_v3(Animal,RecDate,Channel,'n'); % small and large stdiff only
% plot_ExampleMUA_v3_2(Animal,RecDate,Channel,'n'); % small and large stdiff only
% plot_ExampleMUA_v4_2(Animal,RecDate,Channel,'n'); % smoothed
plot_ExampleMUA_v4_2_gr(Animal,RecDate,Channel,'n'); % gray scale
exportgraphics(gcf,fullfile(save_file_dir,'ExampleMUA_BELT1.eps'),'Resolution',600);

% % choose another example (the one shows difference between hit and miss)...
% Animal = 'Cassius';
% RecDate = '20210220';
% Channel = 5;
% % plot_ExampleMUA_v3(Animal,RecDate,Channel,'y'); % small and large stdiff only
% plot_ExampleMUA_v3_2(Animal,RecDate,Channel,'y'); % small and large stdiff only
% exportgraphics(gcf,fullfile(save_file_dir,'ExampleMUA_BELT2.eps'),'Resolution',600);

% choose another example (the one shows difference between hit and miss)...
Animal = 'Cassius';
RecDate = '20210111';
Channel = 23;
% plot_ExampleMUA_v3(Animal,RecDate,Channel,'y'); % small and large stdiff only
% plot_ExampleMUA_v3_2(Animal,RecDate,Channel,'y'); % small and large stdiff only
% plot_ExampleMUA_v4_2(Animal,RecDate,Channel,'y'); % smoothed
plot_ExampleMUA_v4_2_gr(Animal,RecDate,Channel,'y'); % gray scale
exportgraphics(gcf,fullfile(save_file_dir,'ExampleMUA_CORE2.eps'),'Resolution',600);