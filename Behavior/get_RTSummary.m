function [RTSummary] = get_RTSummary(RT)
medRT = nanmedian(RT); % median
iqrRT = iqr(RT); % interquartile range

% time corresponding to the peak distribution
[f,x] = ksdensity(RT);
peakRT = x(f==max(f));

RTSummary = [medRT peakRT iqrRT];
end