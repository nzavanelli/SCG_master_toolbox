%% DEFINE ECG AND SCG SIGNALS
% hux = hux_full;
ix = 1:height(hux);
% ix = 3e6:3.2e6;
% ix = istart_hux:height(hux);
fs = 500;
time = (1:length(ix)) / fs;

ecg = -hux.ecg(ix);
scg = hux.z1(ix);
% time = hux.time(ix);

%% FILTER SIGNALS AND EXTRACT R PEAKS
ecg_f = filter_ecg(ecg,500,0);
scg_f = filter_scg(scg,500,[8 30],0);
pcg_f = filter_scg(scg,500,[30 80],0);
[rpx,rix] = detect_R_peaks_wavelet(ecg,500,0);

%% SEGMENT CYCLES
[~,M_scg] = segment_cycles(scg_f,rix/500,500,0);
[~,M_pcg] = segment_cycles(pcg_f,rix/500,500,0);
[~,M_ecg] = segment_cycles(ecg_f,rix/500,500,0);

%% ONLY KEEP CYCLES OF APPROPRIATE LENGTH
sigma = 0.25;
[S_ecg,keep,toss] = select_sized_cycles(M_ecg,sigma,1);
S_scg = select_sized_cycles(M_scg,sigma,1);
S_pcg = select_sized_cycles(M_pcg,sigma,1);

%% ISOLATE SCG BEATS WITH IDENTIFIABLE SYSTOLIC EVENTS
% std_threshold = 5e3;
% [scg_sys,AO,IVC,AOmag,IVCmag] = select_systolic_scg(S_scg,std_threshold);

timewindow_s1 = [0.12 0.18];
timewindow_s2 = [0.34 0.6];
% neighbor = 'nearest';
neighbor = 'before';
[AO,AO_magn,IVC,IVC_magn,MC,MC_magn] = detect_SCG_fiducials_movstd(S_scg,fs,timewindow_s1,1);
[~,~,~,~,AC,AC_magn] = detect_SCG_fiducials_movstd(S_scg,fs,timewindow_s2,0);
hold on;
scatter(AC,AC_magn,20,[0.1 0.8 0.3],'filled','markerfacealpha',0.3);

%% ENVELOPE PCG AND EXTRACT MC POINT ESTIMATE
[pcg_env,MC_pcg] = envelope_pcg(S_pcg,1);

%% GET BEAT-TO-BEAT SIMILARITY OF SCG
for cyc = 1:size(S_scg,2)-1
    beat1 = S_scg(:,cyc);
    beat2 = S_scg(:,cyc+1);
    sm(cyc,:) = beat_to_beat_similarity(beat1,beat2,500,'xc'); 
end 

%%
figure;
sp(1) = subplot(311);
plot(keep,AO,'.')
title('AO')
sp(2) = subplot(312);
plot(keep,IVC,'.')
title('ICP')
sp(3) = subplot(313);
plot(keep,MC,'.')
title('MC')
linkaxes(sp,'x');

figure;
sp2(1) = subplot(211);
plot(sm(:,1));
title('Cross-correlation');
sp2(2) = subplot(212);
plot(sm(:,2));
title('Lags');
linkaxes(sp2,'x');
