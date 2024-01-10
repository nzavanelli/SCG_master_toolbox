function my_spectrogram (x, segs, freq_res, overlap, fs)

Nx = length(x);
ns = segs;
ov = overlap;
win = floor(Nx./ns);
no = floor(win.*ov);

res = (freq_res-1).*2;
spectrogram(x,win,no,res,fs, 'yaxis') 

% caxis([dbmin, dbmax])
end