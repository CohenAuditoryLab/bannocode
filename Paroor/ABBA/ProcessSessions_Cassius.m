clear all

addpath('D:\Matlab_code_cassius\MUA\RAW2MUA');

% list data for analysis
list_data = {'20210313'}; % test
% list_data = {'20201127','20201202', '20201214', '20201221', ...
%     '20210104','20210106','20210111','20210208','20210210','20210213', ...
%     '20210220','20210222','20210224','20210306','20210308','20210310', ...
%     '20210313','20210317','20210324','20210331','20210403'};
% list_data = {'20210317','20210324','20210331','20210403'};

N = numel(list_data);
for ff=1:N
    rec_date = list_data{ff};
    disp(strcat('Processing ', num2str(ff), '/', num2str(N)));
    
    % get behavior file without having 'invalid' FA trials...
%     removeInvalidFAfromBehavABBA(rec_date);
    
    % convert raw data into MUA
    convertRAW2MUA(rec_date);
    
    clc;
end

disp('done!');