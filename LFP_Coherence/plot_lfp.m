function [] = plot_lfp(t,LFP,label,params)
%plot_lfp Summary of this function goes here
%   plot LFP as a function time in each electrode
%   t     -- time vector
%   LFP   -- LFP data (channel x sample x trial)
%   label -- electrode/channel label
%   params -- parameters for display
%             - errortype; either 'std' or 'ste'
%             - color; line color either symbol or numbers
%             - isTitle; either 'y' or 'n' to show title or not
etype   = params.errortype;
col     = params.color;
isTitle = params.isTitle;

n_ch = size(LFP,1); % number of channel
n_trial = size(LFP,3); % number of trial
% c = parula(n_ch); % specify color map to use

mLFP = mean(LFP,3); % mean
sLFP = std(LFP,[],3); % standard deviation
eLFP = sLFP / sqrt(n_trial); % standard error

% if n_ch==14 % 16-ch electrode
%     ch_label = {'ch02','ch03','ch04','ch05','ch06','ch07','ch08','ch09','ch10','ch11','ch12','ch13','ch14','ch15'};
% elseif n_ch==20 % 24-ch electrode
%     ch_label = {'ch03','ch04','ch05','ch06','ch07','ch08','ch09','ch10','ch11','ch12','ch13','ch14','ch15','ch16','ch17','ch18','ch19','ch20','ch21','ch22'};
% end


for i=1:n_ch
    if n_ch==14
        subplot(3,5,i);
    elseif n_ch==20
        subplot(4,5,i);
    end
    m_lfp = mLFP(i,:);
    if strcmp(etype,'std')
        e_lfp = sLFP(i,:);
    elseif strcmp(etype,'ste')
        e_lfp = eLFP(i,:);
    end
    % plot
    fill([t fliplr(t)],[m_lfp+e_lfp fliplr(m_lfp-e_lfp)],col,'FaceAlpha',0.3,'linestyle','none'); hold on;
    plot(t,mLFP(i,:),col);
    
    xlabel('Time [Sec]'); ylabel('uV');
    set(gca,'xlim',[t(1) t(end)+0.01]);
    if strcmp(isTitle,'y')||strcmp(isTitle,'Y')||isTitle==1
        title(label{i},'Interpreter','none');
    end
    box off;
end




% s = inputname(2);
% if strcmp(s(end),'c')
%     s_title = [string ' correct'];
% elseif strcmp(s(end),'w')
%     s_title = [string ' wrong'];
% elseif strcmp(s(end),'d')
%     s_title = [string ' difference'];
% end
% title(s_title);
% 
% box off;

end