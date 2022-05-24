function [data_char] = convertCell2Char(data_cell)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% pretone
% Low -> L, High -> H, None -> N
data_cell(strcmp(data_cell,'Low')) = {'L'};
data_cell(strcmp(data_cell,'High')) = {'H'};
data_cell(strcmp(data_cell,'None')) = {'N'};

% choice name
% noChoice -> N
data_cell(strcmp(data_cell,'noChoice')) = {'N'};

% ErrorName
% correct -> C, wrong -> W
data_cell(strcmp(data_cell,'correct')) = {'C'};
data_cell(strcmp(data_cell,'wrong')) = {'W'};

% comvert cell into char
data_char = cell2mat(data_cell);

end

