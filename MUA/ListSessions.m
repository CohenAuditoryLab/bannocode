clear all;

addpath(genpath('RAW2MUA')); % directory for analysis code...
animal_name = 'Domo';
list_date = {'20180709','20180727','20180807','20180907', ...
    '20181210','20181212','20190123','20190409','20190821', ...
    '20190828','20191009','20191210','20191220','20200103','20200110','20200114'};

for ff=16 %1:numel(list_date)
    RecDate = list_date{ff};
    disp(['processing ' RecDate]);
    
    convertRAW2MUA_v2(animal_name,RecDate);
end