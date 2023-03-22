

function [cids, amp, ch, depth, fr, cgs, nspikes, sh] = readClusterInfoCSV(filename)
%function [cids, amp, ch, depth, fr, cgs, nspikes, sh] = readClusterInfoCSV(filename)
% cids is length nClusters, the cluster ID numbers
% cgs is length nClusters, the "cluster group":
% - 0 = noise
% - 1 = mua
% - 2 = good
% - 3 = unsorted
% - 4 = drift

fid = fopen(filename);
C = textscan(fid, '%s%s%s%s%s%s%s%s');
fclose(fid);

cids = cellfun(@str2num, C{1}(2:end), 'uni', false);
ise = cellfun(@isempty, cids);
cids = [cids{~ise}];

amp = cellfun(@str2num, C{2}(2:end), 'uni', false);
amp = [amp{~ise}];

ch = cellfun(@str2num, C{3}(2:end), 'uni', false);
ch = [ch{~ise}];

depth = cellfun(@str2num, C{4}(2:end), 'uni', false);
depth = [depth{~ise}];

fr = cellfun(@str2num, C{5}(2:end), 'uni', false);
fr = [fr{~ise}];

isUns = cellfun(@(x)strcmp(x,'unsorted'),C{6}(2:end));
isMUA = cellfun(@(x)strcmp(x,'mua'),C{6}(2:end));
isGood = cellfun(@(x)strcmp(x,'good'),C{6}(2:end));
isDrift = cellfun(@(x)strcmp(x,'drift'),C{6}(2:end)); % added by TB
cgs = zeros(size(cids));

cgs(isMUA) = 1;
cgs(isGood) = 2;
cgs(isUns) = 3;
cgs(isDrift) = 4; % added by TB

nspikes = cellfun(@str2num, C{7}(2:end), 'uni', false);
nspikes = [nspikes{~ise}];

sh = cellfun(@str2num, C{5}(2:end), 'uni', false);
sh = [sh{~ise}];