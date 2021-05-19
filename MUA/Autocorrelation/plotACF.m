function [ H ] = plotACF( ACF_all, list_st )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
nChannel = size(ACF_all,1);

H(1) = figure;
for c = 1:nChannel
    ACF_ch = ACF_all(c,:,:);
    if nChannel==16
        subplot(4,4,c);
    else
        subplot(4,6,c);
    end
    plot(ACF_ch(:,:,1),'-o'); hold on; %hit
    plot(ACF_ch(:,:,2),':^');
    title(strcat('ch',num2str(c)));
    set(gca,'XLim',[0 length(list_st)+1],'XTick',1:length(list_st),'XTickLabel',list_st);
end

% compare hit vs miss
H(2) = figure;
for i=1:length(list_st)
    ACF_stdiff = permute(ACF_all(:,i,:),[1 3 2]);
    subplot(2,2,i);
    x = 1:nChannel;
    h = bar(x,ACF_stdiff);
    %set(B(1),'LineWidth',25);
    title(strcat(num2str(list_st(i)),' semitone difference'));
    set(h(1),'FaceColor','red','BarWidth',1);
    set(h(2),'FaceColor','blue','BarWidth',1);
    xlabel('Electrode Contact');
    ylabel('xCorr');
    xlim([0 nChannel+1]);
end

end

