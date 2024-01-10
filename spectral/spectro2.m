function [] = spectro2(xn,fs,twin,overlap,wintype,plotOn)

if isempty(wintype)
    wintype = 'hamm';
end

%% Spectrogram parameters
winlen = round(fs*twin);
switch wintype
    case 'hann'
        window = hann(winlen);
    case 'hamm'
        window = hamming(winlen);
    case 'rect'
        window = rectwin(winlen);
    case 'kaiser'
        window = kaiser(winlen,12.26);
end

overlapPct = overlap*100;                    % percent of window to overlap
nfft = winlen;           % # FFTs to compute ([] -> default #)

%% Display
if plotOn
    figure;
    sp(1) = subplot(2,1,1);   
    plot((1:length(xn))/fs/60,xn)
    title('Waveform')
    sp(2) = subplot(2,1,2);
    spectrogram(xn,window,overlapPct,nfft,fs,'yaxis'); 
    title('Spectrogram')
    colorbar;
    linkaxes(sp,'x');
end

end