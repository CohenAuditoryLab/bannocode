function [cleanData] = removeNoisySpikes(Data)
%removeNoisySpike Summary of this function goes here
%   remove noise from spike train stored in TDT
%   TDT stores spike time of noise in sortcode = 31 

cleanData = Data; % copy original data

Snips = Data.Snips;
SnipTimeStamp = Data.SnipTimeStamp;
SortCode = Data.SortCode;
ChannelNumber = Data.ChannelNumber;

Snips1 = Data.Snips1;
SnipTimeStamp1 = Data.SnipTimeStamp1;
SortCode1 = Data.SortCode1;
ChannelNumber1 = Data.ChannelNumber1;

% remove noise (SortCode==31)
Snips(SortCode==31) = [];
SnipTimeStamp(SortCode==31) = [];
ChannelNumber(SortCode==31) = [];
SortCode(SortCode==31) = [];

Snips1(SortCode1==31) = [];
SnipTimeStamp1(SortCode1==31) = [];
ChannelNumber1(SortCode1==31) = [];
SortCode1(SortCode1==31) = [];

% overwrite data
cleanData.Snips = Snips;
cleanData.SnipTimeStamp = SnipTimeStamp;
cleanData.SortCode = SortCode;
cleanData.ChannelNumber = ChannelNumber;
cleanData.Snips1 = Snips1;
cleanData.SnipTimeStamp1 = SnipTimeStamp1;
cleanData.SortCode1 = SortCode1;
cleanData.ChannelNumber1 = ChannelNumber1;

end

