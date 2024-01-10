function [fft_avg,fft_sd,frq] = compute_fft_avg_interval(X,fs,twin,overlap,plotOn)

len = length(X);
time = (1:len) / fs;
winlen = round(twin * fs);
winshift = round(twin * (1-overlap) * fs);

i1 = 1;
incr = 1;
while i1 < (len - winlen)
    i2 = i1 + winlen;
    frame = i1:i2;
    snippet = X(frame);
    
    [FFT(:,incr),FRQ(:,incr)] = compute_fft(snippet,fs,0);
    
    i1 = i1 + winshift;
    incr = incr + 1;
end

%%% TODO -> ADD END CONDITION

[fft_avg,fft_sd] = ens_avg_mat(FFT,0);
frq = FRQ(:,1);

if plotOn
    figure;
    hold on;
    plot(FRQ(:,1),fft_avg,'linewidth',2,'color',0*[1 1 1]);
    plot(FRQ(:,1),fft_avg+fft_sd,'linewidth',0.5,'color',0.5*[1 1 1]);
    plot(FRQ(:,1),fft_avg-fft_sd,'linewidth',0.5,'color',0.5*[1 1 1]);
end

end