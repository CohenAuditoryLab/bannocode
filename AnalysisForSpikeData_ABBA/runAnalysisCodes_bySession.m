% list session for analysis
clear all;
% list_session = {'20201123'};
% list_session = {'20201127','20201202','20201214','20201221', ...
%     '20210104','20210106','20210111','20210208','20210210','20210213', ...
%     '20210220','20210222','20210224','20210306','20210308','20210310', ...
%     '20210313','20210317','20210324'};

% list_session = {'20180807_ABBA_d01','20180907_ABBA_d01','20181210_ABBA_d01',...
%     '20181212_ABBA_d01','20190123_ABBA_d02','20190409_ABBA_d01'};

% list_session = {'20190821_ABBA_d02','20190828_ABBA_d02','20191009_ABBA_d03', ...
%     '20191210_ABBA_d02','20191220_ABBA_d01','20200103_ABBA_d01','20200110_ABBA_d01','20200114_ABBA_d02'};

list_session = {'20210403_ABBA_d02'};

% run analysis code...
for ff=1:numel(list_session)
    session_name = list_session{ff};
    rec_date = session_name(1:8);
    
    disp(['Working on the data: ' session_name]);
    
%     % run checkAuditoryResponse
% %     checkAuditoryResponse(session_name); % Domo's data before 20190409
%     checkAuditoryResponse_phy2_Domo(session_name); % Domo's data after 20190821
% %     checkAuditoryResponse_phy2_Cassius(session_name) % Cassius's data
%     close all;
    
    % run Raster_triplet
    Raster_triplet(rec_date);
    
    % run SDF_triplet
    SDF_triplet(rec_date);
    close all;
    
    % run displayTripletQuantificationSummary
    displayTripletQuantificationSummary(rec_date);
    close all;
    
    % run obtainFiringRate
    obtainFiringRate_v3(rec_date);
    close all;
    
    % run QuantifyFR_ROC
    % be sure to change the number of channels before run
    QuantifyFR_ROC(rec_date);
    close all;
    
    % run obtainVectorStrength
    obtainVectorStrength(rec_date);
    close all;
    
    % run displayAbsDPrimeSummary
    % be sure to change the number of channels before run
    displayAbsDPrimeSummary(rec_date);
    close all;
    
    % run displayVectorStrengthSummary
    % be sure to change the number of channels before run
    displayVectorStrengthSummary(rec_date);
    close all;
    
    clc;
end