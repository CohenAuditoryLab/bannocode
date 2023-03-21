clear all;

addpath('RAW2MUA'); % directory for analysis code...
animal_name = 'Cassius';
list_date = {'20201123','20201127','20201202','20201214','20201221', ...
    '20210104','20210106','20210111','20210208','20210210','20210222', ...
    '20210224','20210306','20210308','20210310','20210317','20210324', ...
    '20210331','20210403'};

for ff=1:numel(list_date)
    RecDate = list_date{ff};
    disp(['processing ' RecDate]);
    
    convertRAW2MUA_v2(animal_name,RecDate);
end