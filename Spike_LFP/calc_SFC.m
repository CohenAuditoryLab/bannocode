function [coherence,coherogram,H] = calc_SFC(lfp_ch,raster_cl,t,info)
% calculate spike-field coherence with shift predictor
% plot SFC along the depth (from channel 1 to 16)
% cf. Takeda et al., 2015, 2018; Kohn and Smith 2005


% electrodeID_lfp = info.lfp.EID;
% electrodeID_spk = info.spk.EID;
ch = info.lfp.ch;
cl = info.spk.cl;

% set analysis period for coherency (make it empty when using whole length)
cPeriod = [0 0.2]; % [];

% set variables
alpha = 0.01; % for confidence interval (0.05 for 95% CI)
movingwin = [0.2 0.02]; %[0.5 0.05]; % sliding window for coherogram

% set parameters for spectrum analysis (Chronux format)
params.Fs = 1000; %param.SF;
params.fpass = [0 100];
params.tapers = [5 9]; %[3 5];
params.pad = 1; % default is 0
params.trialave = 1;
params.err = [1 alpha]; % [1 p] - Theoretical error bars; [2 p] - Jackknife error bars
% params.err = 0;


% get trial shifted LFP and Spikes
lfp_sh = lfp_ch(:,2:end);
raster_sh = raster_cl(:,1:end-1);

% cut out lfp and raster for the coherency
if isempty(cPeriod)
    slfp_ch = lfp_ch;
    slfp_sh = lfp_sh;
    sraster_cl = raster_cl;
    sraster_sh = raster_sh;
else
    slfp_ch = lfp_ch(t>cPeriod(1) & t<=cPeriod(2), : );
    slfp_sh = lfp_sh(t>cPeriod(1) & t<=cPeriod(2), : );
    sraster_cl = raster_cl(t>cPeriod(1) & t<=cPeriod(2), : );
    sraster_sh = raster_sh(t>cPeriod(1) & t<=cPeriod(2), : );
end


% compute coherence
% [C,phi,S12,S1,S2,f] = coherencycpb(lfp_ch,raster_cl,params);
[C,phi,S12,S1,S2,f] = coherencycpb(slfp_ch,sraster_cl,params); % specified time window
% [C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr] = coherencycpb(lfp_ch,raster_cl,params); % w/ conf interval

% compute coherogram
[Cmat,phimat,S12,S1,S2,tt,ff] = cohgramcpb(lfp_ch,raster_cl,movingwin,params);
tt = tt + t(1);
% % when params.err = [2 p], slow...
% [C,phi,S12,S1,S2,t,f,zerosp,confC,phistd,Cerr] = cohgramcpb(lfp_ch,raster_cl,movingwin,params);
% % get significant coherogram...
% % C_sig = C; C_sig(C<confC) = NaN; % make non-significant pixels be zero
% % phi_sig = phi; phi_sig(C<confC) = NaN;
% C_lb = squeeze(Cerr(1,:,:));
% C_sig = C; C_sig(C_lb<confC) = NaN; % use lower boundary to get significant pix
% phi_sig = phi; phi_sig(C_lb<confC) = NaN;
% U = cos(phi_sig);
% V = sin(phi_sig);

% trial shift predictor
% compute coherence (shuffled trial)
% [ C_sh, phi_sh ] = coherencycpb(lfp_sh,raster_sh,params);
[ C_sh, phi_sh ] = coherencycpb(slfp_sh,sraster_sh,params); % specified time window
% compute coherogram (shuffled trial)
[ Cmat_sh, phimat_sh ] = cohgramcpb(lfp_sh,raster_sh,movingwin,params);

    
% plot coherence
H = figure('Position',[50 50 500 700]);
subplot(3,1,3);
plot_vector(C_sh,f,'n',[],':k'); hold on;
plot_vector(C,f,'n',[],'r',1.5); % should not take log for coherence
set(gca,'XLim',params.fpass);
xlabel('frequency [Hz]'); ylabel('coherence');
% title(['channel ' num2str(ch)]);
if isempty(cPeriod)
    title('coherence in whole period');
else
    title(['coherence in: ' num2str(cPeriod(1)) ' - ' num2str(cPeriod(2)) ' sec']);
end
box off;

C_diff = C - C_sh;
coherence = struct('C',C,'C_sh',C_sh,'C_diff',C_diff,'f',f);

% plot coherogram
subplot(3,1,1);
plot_matrix(Cmat,tt,ff,'n'); % should not take log for coherence
% pcolor(t,f,C'); shading('interp');
xlabel('time [sec]'); ylabel('frequency [Hz]');
% set(gca,'XTick',0.1:0.1:0.9,'XTickLabel',0:0.1:0.8);
% set(gca,'XTick',0.1:0.2:1.3,'XTickLabel',-0.6:0.2:0.6);
title('spike-field coherogram');
% caxis([8 28]);
colormap jet

% plot shift-predictor-subtracted coherogram (shuffled trial)
subplot(3,1,2);
Cmat_diff = Cmat - Cmat_sh;
plot_matrix(Cmat_diff,tt,ff,'n'); % should not take log for coherence
% pcolor(t,f,C'); shading('interp');
xlabel('time [sec]'); ylabel('frequency [Hz]');
% set(gca,'XTick',0.1:0.1:0.9,'XTickLabel',0:0.1:0.8);
% set(gca,'XTick',0.1:0.2:1.3,'XTickLabel',-0.6:0.2:0.6);
title('shift-predictor-subtracted SFC');
% caxis([8 28]);
colormap jet

coherogram = struct('Cmat',Cmat,'Cmat_sh',Cmat_sh,'Cmat_diff',Cmat_diff,'tt',tt,'ff',ff);

% % works only when params.err = [2 p]...
% % plot phase
% figure;
% plot_matrix(phi_sig,t,f,'n'); % should not take log for coherence
% % pcolor(t,f,C'); shading('interp');
% xlabel('time [sec]'); ylabel('frequency [Hz]');
% % set(gca,'XTickLabel',0:0.5:2.5);
% title('spike-LFP coherogram (phase)');
% % caxis([8 28]);
% % colormap jet
% 
% % phase distribution
% edges = -pi:pi/12:pi;
% p_up = phi_sig; p_up(:,f<50) = NaN;
% p_down = phi_sig; p_down(:,f>=50) = NaN;
% figure;
% subplot(2,2,1);
% polarhistogram(phi_sig,edges);
% title('All');
% subplot(2,2,3);
% polarhistogram(p_down,edges);
% title('below 50 Hz');
% subplot(2,2,4);
% polarhistogram(p_up,edges);
% title('above 50 Hz');
end