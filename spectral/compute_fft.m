function [Xfft,f] = compute_fft(X,fs,plotOn)

if nargin < 3
    plotOn = 0;
end

L = length(X);
Lhalf = round(L/2);
Y = fft(X);
% Y = fft(X,nfft);
P2 = abs(Y/L);
P1 = P2(1:Lhalf+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:Lhalf)/L;
Xfft = P1;

if plotOn
    figure;
    hold on;
    plot(f(2:end),P1(2:end));
    title('Single-Sided Amplitude Spectrum of X(t)');
    xlabel('f (Hz)');
    ylabel('|P1(f)|');
    xlim([0 fs/2]);
end
    
end