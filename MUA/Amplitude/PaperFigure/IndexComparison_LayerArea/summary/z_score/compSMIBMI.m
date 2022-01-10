function [index] = compSMIBMI(zSMI,zBMI)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% index = (zBMI-zSMI) ./ (zBMI+zSMI);
index = zBMI-zSMI;
end