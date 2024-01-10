function [wm] = welchs_method(xn,fs,wintype,winlen,overlap,plotOn)
% *** Compute power spectral density of signal based on Welch's Method
% INPUT    
%     - xn : Nx1 signal vector
%     - fs : sampling rate (Hz)
%     - wintype : 'hann' (Hanning) // 'rect' (rectangular) // 'kaiser'
%     - winlen : length of fft window (s)
%         * smaller -> less 'noisy' / larger -> higher freq resolution
%     - overlap : pct overlap of fft windows [0 -> 1]
%     - plotOn : plot result (1) or not (0)
% OUTPUT   
%     - wm: struct containing power spectral density and freq info
%         wm.pxx : power density at given frequency
%         wm.frq : frequency (hz)
%         wm.pxx_dB : power density in dB
%         wm.pxx_dB_rmsnorm : power density in dB referenced to signal RMS
%         wm.pxx_dB_1kHz : power density in dB referenced to that at 1 kHz

if nargin < 3
    wintype = 'hann';
    winlen = [];    % NFFT will default to default #
    overlap = [];   % will default to 50%
    plotOn = 0;
elseif nargin == 5
    plotOn = 0;
end

%% Welch's method setup parameters
% fs = 1e5;                           % sampling rate (Hz)
% winlen = round(length(xn)/100); % smaller window -> reduced noise, wider window -> greater freq resolution
% % windowSize = round(length(xn)/1); % smaller window -> reduced noise, wider window -> greater freq resolution
% overlap = [];                       % samples of window to overlap ([] = 50%)
% NFFT = round(winlen);           % # FFTs to compute ([] -> default #)
% FREQRANGE = 'onesided';   
% fv = linspace(1,fs,fs);              % frequency vector

winsamples = round(winlen*fs);
NFFT = winsamples;
if ~isempty(overlap)
    overlap = round(overlap*NFFT);
end
FREQRANGE = 'onesided';   
fv = linspace(1,fs,fs);              % frequency vector

switch wintype
    case 'hann'
%         window = hann(winlen);          % Hanning window
        window = hann(winsamples);          % Hanning window
    case 'hamm'
        window = hamming(winsamples);       % Hamming window
    case 'rect'
%         window = rectwin(winlen);       % rectangular window
        window = rectwin(winsamples);       % rectangular window
    case 'kaiser'
%         window = kaiser(winlen,12.26);  % Kaiser window, 120 dB side lobe attenuation
        window = kaiser(winsamples,12.26);  % Kaiser window, 120 dB side lobe attenuation
end

%% Normal periodogram, rectangular window (for comparison)
% periodogram(xn,rectwin(length(xn)),1024,fs)

%% Perform Welch's method
[wm.pxx,wm.frq] = pwelch(xn,window,overlap,NFFT,fs,FREQRANGE);
% [wm.pxx,wm.frq] = pwelch(xn,window,noverlap,fv,fs,FREQRANGE);
wm.pxx_dB = 10*log10(wm.pxx);
wm.pxx_dB_rmsnorm = wm.pxx_dB ./ rms(xn);
[~,idx_1kHz] = min(abs(wm.frq-1000));
pxx_dB_at_1kHz = wm.pxx_dB(idx_1kHz,:);
wm.pxx_dB_1kHz = wm.pxx_dB(:,:) / pxx_dB_at_1kHz;

%% Feature extraction
% ix_100 = 36;   % index at trough of initial region (~100 Hz) -- might change based on fs !
% ix_10k = 3501;
% ix_20k = 7001;
% dB_max = max(wm.pxx_dB(ix_100:end)); 
% wm.dB_max = dB_max;
% wm.dB_max_f = wm.frq(wm.pxx_dB == dB_max);
% dB_plateau = mean(wm.pxx_dB(ix_10k:ix_20k));
% wm.dB_auc = trapz(wm.pxx_dB(ix_100:ix_10k)-dB_plateau);

%% Display
if plotOn 
    figure;
    hold on;
    plot(wm.frq,wm.pxx);
%     plot(wm.frq,wm.pxx_dB);
%     plot(wm.frq,wm.pxx_dB_rmsnorm);
    xlim([0 fs/2])
    % ylim([-170 -120])
%     legend;

    set(gca,'Xscale','linear');
    set(gca,'Yscale','log');  
    title('Welch Power Spectral Density')
    ylabel('Power / Frequency')
    xlabel('Frequency (Hz)')
else
    % nuddin
end