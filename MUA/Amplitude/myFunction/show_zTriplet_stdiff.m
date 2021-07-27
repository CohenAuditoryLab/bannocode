function [ fig_handle, fig_name ] = show_zTriplet_stdiff( zABB_stdiff, list_st, RecDate )
% take the response to the 1st, 2nd, 3rd, T-1 and target triplet and show
% the average of them in a bargraph as a function of channels

th = 1.96; % 95% threshold of z-score
% th = 2.58; % 99% threshold of z-score
nChannel = size(zABB_stdiff,3);
string = {'A','B1','B2'};
pos = [1 3 4];
for i=1:length(list_st)
    fig_handle(i) = figure;
    for j=1:3 % ABB
        H(j) = subplot(2,2,pos(j));
        h = bar(squeeze(mean(zABB_stdiff(j,:,:,i,:),2))); hold on; % averaged over triplet position...
        set(h(1),'FaceColor','r');
        set(h(2),'FaceColor','b');
        xlabel('channel'); ylabel('area under the MUA [z-score]');
        title(string{j});
        box off;
        
        plot([0 nChannel+1],[th th],':k');
        plot([0 nChannel+1],[-th -th],':k');
        
        y_lim = get(gca,'YLim');
        y_min(j) = y_lim(1);
        y_max(j) = y_lim(2);
        clear y_lim
    end
    set(H,'XLim',[0 nChannel+1],'YLim',[min(y_min) max(y_max)]);
    fig_name{i} = strcat(RecDate,'_zTripletResp_',num2str(list_st(i)),'stdiff');
%     if isSave==1
%         % save figure
%         fig_name = strcat(params.RecordingDate,'_zTripletResp_',num2str(list_st(i)),'stdiff');
%         saveas(gcf,fullfile(SAVE_DIR,params.RecordingDate,'RESP',fig_name),'png');
%     end
    clear y_min y_max H
end

end