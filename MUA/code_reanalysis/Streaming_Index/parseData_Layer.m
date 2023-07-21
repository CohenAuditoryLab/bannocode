function [lData] = parseData_Layer(Data,iDepth)
%UNTITLED3 Summary of this function goes here
%   separate data into layers
%   Data must be 5D matrix (ch x hard-easy x hit-miss x session x tpos)

nSession = size(Data,4); % number of recording sessions
Data_sup = []; Data_mid = []; Data_dep = [];
for i=1:nSession
    data_session = squeeze(Data(:,:,:,i,:));
    iDepth_session = iDepth(:,i);

%     if ~isnan(iDepth_session(1))
        data_sup = data_session(iDepth_session==0,:,:,:);
        data_mid = data_session(iDepth_session==1,:,:,:);
        data_dep = data_session(iDepth_session==2,:,:,:);
%     end
    
    % concatenate data
    Data_sup = cat(1,Data_sup,data_sup);
    Data_mid = cat(1,Data_mid,data_mid);
    Data_dep = cat(1,Data_dep,data_dep);

    clear data_sup data_mid data_dep
end

lData.sup = Data_sup;
lData.mid = Data_mid;
lData.dep = Data_dep;

end