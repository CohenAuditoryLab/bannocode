% generete figure showing example MUA from CORE and BELT

% choose example from CORE
Animal = 'Domo';
RecDate = '20180709';
Channel = 9;
% generate figure
% plot_ExampleMUA(Animal,RecDate,Channel);
plot_ExampleMUA_v2(Animal,RecDate,Channel); % small and large stdiff only

% choose example from BELT
Animal = 'Domo';
RecDate = '20200110';
Channel = 7;
% generate figure
% plot_ExampleMUA(Animal,RecDate,Channel);
plot_ExampleMUA_v2(Animal,RecDate,Channel); % small and large stdiff only

% choose another example (the one shows difference between hit and miss)...
Animal = 'Cassius';
RecDate = '20210220';
Channel = 5;
plot_ExampleMUA_v2(Animal,RecDate,Channel); % small and large stdiff only