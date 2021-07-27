function [ fig_handle, fig_name ] = show_zTriplet_ttime( zABB_ttime, list_tt, RecDate )
% take the responses to the target triplet and display them in a bar graph
% as a function of channels.

th = 1.96; % 95% threshold of z-score
% th = 2.58; % 99% threshold of z-score
nChannel = size(zABB_ttime,3);
string = {'A','B1','B2'};
pos = [1 3 4];
for i=1:length(list_tt)
    fig_handle(i) = figure;
    for j=1:3 % ABB
        H(j) = subplot(2,2,pos(j));
%         h = bar(squeeze(mean(zABB_ttime(j,:,:,i,:),2))); hold on;
        h = bar(squeeze(mean(zABB_ttime(j,5,:,i,:),2))); hold on; % response to the target
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
    fig_name{i} = strcat(RecDate,'_zTripletResp_TT',num2str(list_tt(i)),'ms');
%     if isSave==1
%         % save figure
%         fig_name = strcat(params.RecordingDate,'_zTripletResp_',num2str(list_st(i)),'stdiff');
%         saveas(gcf,fullfile(SAVE_DIR,params.RecordingDate,'RESP',fig_name),'png');
%     end
    clear y_min y_max H
end

end