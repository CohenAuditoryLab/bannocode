function [reshapeBMI] = reshapeBMI_target(BMI_matrix)
%UNTITLED2 Summary of this function goes here
%   reshape BMI matrix from (channel) x (target_time) x (session) to (channel) x
%   (ttime) by removing NaNs

reshapeBMI = [];
nSession = size(BMI_matrix,3);
nTT = size(BMI_matrix,2);
perm_vector = [nTT 1:(nTT-1)];
for i=1:nSession
    bmi_mat = BMI_matrix(:,:,i); % (channel) x (target_time)
    index = 1:size(bmi_mat,1);
    iSigChannel = index(~isnan(bmi_mat(:,1)));
    bmi_sig = bmi_mat(iSigChannel,:);
    
    if ~isempty(bmi_sig)
    temp = bmi_sig(1,end);
    while isnan(temp)
        bmi_sig = bmi_sig(:,perm_vector);
        temp = bmi_sig(1,end);
    end
    end
    reshapeBMI = [reshapeBMI; bmi_sig];
    clear bmi_sig iSigChannel
end