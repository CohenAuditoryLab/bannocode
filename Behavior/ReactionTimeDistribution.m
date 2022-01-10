clear all;

DATA_DIR = 'E:\01_Research\01_STREAM_INTEGRATION&SEGREGATION\ANALYSIS\Behavior\Data';
animal_name = 'Cassius';
bin_width = 25;

% % % % Reaction Time Distribution % % % % 
if strcmp(animal_name,'Domo')
    load RecordingDate_Domo; % get list of recordiaang date...
    rt_range = [0 650]; % reaction time range for plot
    string = 'monkey D';
elseif strcmp(animal_name,'Cassius')
    load RecordingDate_Cassius;
    rt_range = [0 800];
    string = 'monkey C';
end
RecDate = list_RecDate;

RT_hit = []; RT_fa = [];
RT_sdf_hit = []; RT_sdf_fa = [];
RT_ldf_hit = []; RT_ldf_fa = [];
for ff=1:numel(RecDate)
    fName = strcat(RecDate{ff},'_Behavior');
    load(fullfile(DATA_DIR,fName)); 
    RT_hit = [RT_hit; cleanRT(rt.all,rt_range)];
    RT_fa  = [RT_fa; cleanRT(rt_tsRT.all,rt_range)];
    
    RT_sdf_hit = [RT_sdf_hit; cleanRT(rt.sdf,rt_range)];
    RT_sdf_fa = [RT_sdf_fa; cleanRT(rt_tsRT.sdf,rt_range)];
    medRT(ff,1) = nanmedian(cleanRT(rt.sdf,rt_range));
    iqrRT(ff,1) = iqr(cleanRT(rt.sdf,rt_range));
%     medRT(ff,1) = nanmedian([cleanRT(rt.sdf,rt_range); cleanRT(rt_tsRT.sdf,rt_range)]);
%     iqrRT(ff,1) = iqr([cleanRT(rt.sdf,rt_range); cleanRT(rt_tsRT.sdf,rt_range)]);
    
    RT_ldf_hit = [RT_ldf_hit; cleanRT(rt.ldf,rt_range)];
    RT_ldf_fa = [RT_ldf_fa; cleanRT(rt_tsRT.ldf,rt_range)];
    medRT(ff,2) = nanmedian(cleanRT(rt.ldf,rt_range));
    iqrRT(ff,2) = iqr(cleanRT(rt.ldf,rt_range));
%     medRT(ff,2) = nanmedian([cleanRT(rt.ldf,rt_range); cleanRT(rt_tsRT.ldf,rt_range)]);
%     iqrRT(ff,2) = iqr([cleanRT(rt.ldf,rt_range); cleanRT(rt_tsRT.ldf,rt_range)]);
    
%     measureRT(ff,:) = get_RTSummary(RT_ldf_hit);
end
figure('Position',[300 300 500 650]);
subplot(3,2,1);
bin = rt_range(1):bin_width:rt_range(2);
histogram(RT_hit,bin); hold on
histogram(RT_fa,bin);
xlabel('time from target onset [ms]');
title(string);
box off;
% RT_summary(1,:) = [nanmedian(RT_hit) iqr(RT_hit)]; % median and iqr of RT
RT_summary(1,:) = get_RTSummary(RT_hit); % median, peak, and iqr of RT
clear RT_hit RT_fa;

subplot(3,2,3);
histogram(RT_sdf_hit,bin); hold on;
histogram(RT_sdf_fa,bin);
title('small dF');
box off;
% RT_summary(2,:) = [nanmedian(RT_sdf_hit) iqr(RT_sdf_hit)];
RT_summary(2,:) = get_RTSummary(RT_sdf_hit);

subplot(3,2,4);
histogram(RT_ldf_hit,bin); hold on;
histogram(RT_ldf_fa,bin);
title('large dF');
box off;
% RT_summary(3,:) = [nanmedian(RT_ldf_hit) iqr(RT_ldf_hit)];
RT_summary(3,:) = get_RTSummary(RT_ldf_hit);

subplot(3,2,5);
boxplot(medRT);
set(gca,'XTickLabel',{'small','large'});
xlabel('frequency separation');
title('median');
box off;

subplot(3,2,6);
boxplot(iqrRT);
set(gca,'XTickLabel',{'small','large'});
xlabel('frequency separation');
title('interquartile range');
box off;

