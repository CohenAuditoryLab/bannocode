animal_name = 'Cassius';

if strcmp(animal_name,'Domo')
    area_index = [1 1 1 1 0 0 0 0 0 0 1 1 1 0 0 0];
    L3u_channel = [7 7 5 7 5 4 6 4 NaN NaN 4 5 NaN 4 4 5]; % L3 upper
    L3_channel = [9 8 8 10 8 6 8 6 4 5 7 7 NaN 6 6 7]; % L3 bottom
    L4_channel = [10 9 9 12 10 8 10 8 5 6 10 9 NaN 8 8 8]; % L4
    L5_channel = [13 12 12 15 13 11 13 11 8 9 13 12 NaN 11 11 11]; % L5
    list_RecDate = {'20180709','20180727','20180807','20180907','20181210', ...
        '20181212','20190123','20190409','20190821','20190828','20191009', ...
        '20191210','20191220','20200103','20200110','20200114'};
elseif strcmp(animal_name,'Cassius')
    area_index = [0 1 1 1 0 0 1 1 1 1 0 0 0 0 1 0 0 0 1 0 0 0];
    L3u_channel = [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN 5 11 10 10 10 8 3];
    L4_channel = [NaN NaN NaN NaN NaN NaN NaN NaN NaN 9 NaN NaN NaN NaN NaN 10 15 14 14 14 13 7];
    L3_channel = [NaN NaN NaN NaN 12 11 NaN 12 10 8 NaN NaN NaN NaN 5 7 13 13 13 13 11 6];
    L5_channel = [NaN NaN NaN NaN NaN NaN NaN NaN NaN 11 NaN NaN NaN NaN NaN 12 17 17 17 17 16 10];
    list_RecDate = {'20201123','20201127','20201202','20201214','20201221', ...
        '20210104','20210106','20210111','20210208','20210210','20210213', ...
        '20210220','20210222','20210224','20210306','20210308','20210310', ...
        '20210313','20210317','20210324','20210331','20210403'};
end

save_file_name = strcat('RecordingDate_',animal_name);
save(save_file_name,'area_index','L3u_channel','L3_channel','L4_channel','L5_channel','list_RecDate');