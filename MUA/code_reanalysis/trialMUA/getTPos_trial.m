function [tpos_trial,sTriplet] = getTPos_trial(targetTime)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

sTriplet = {'1st','2nd','3rd','T-3','T-2','T-1','T','T+1'};
target_position = targetTime / 225 + 1;
n_trial = length(target_position);
for i=1:n_trial
    target = target_position(i);
    rTarget = (target-3):(target+1);
    tpos_trial(i,:) = [1:3 rTarget];
end

end