function [] = spectro(xn,fs)
%% Spectrogram parameters
% fs = 5e4;
% windowSize = round(length(xn)/100); % smaller window -> reduced noise, wider window -> greater freq resolution
windowSize = fs;
% window = hann(windowSize);          % Hanning window
% window = rectwin(windowSize);       % rectangular window
window = kaiser(windowSize,12.26);  % Kaiser window, 120 dB side lobe attenuation
overlapPct = 50;                    % percent of window to overlap
nfft = round(windowSize);           % # FFTs to compute ([] -> default #)

%% Display
figure;
subplot(2,1,1)
ylabel('Audio Waveform')
plot(xn)
subplot(2,1,2)
ylabel('Spectrogram')
spectrogram(xn,window,overlapPct,nfft,fs,'yaxis'); 
colorbar;

end