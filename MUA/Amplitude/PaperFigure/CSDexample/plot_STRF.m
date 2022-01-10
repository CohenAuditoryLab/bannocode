function [strf_param] = plot_STRF(t,f,STRFData,RF1P,ch)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

taxis = t;
faxis = f;
strf = ( STRFData(ch).STRF1A + STRFData(ch).STRF1B ) / 2;
pcolor(taxis,log2(faxis/faxis(1)),strf);
colormap jet;set(gca,'YDir','normal'); shading flat;
%         text(100,7,['BF = ' num2str(RF1P(ch).BFHz) ' Hz'],'FontWeight','bold');
x = RF1P(ch).PeakDelayP;
y = RF1P(ch).PeakBFP;
best_freq = faxis(1) * 2^y; % use peakBF insted of BFHz
latency = x;
set(gca,'YTick',0:2:8,'YTickLabel',{'100','400','1.6k','6.4k','25.6k'});
set(gca,'YLim',[0 max(log2(faxis/faxis(1)))]);
xlabel('Time [ms]'); ylabel('Frequency [Hz]');

strf_param = struct('x',x,'y',y,'latency',latency,'bf',best_freq);
end