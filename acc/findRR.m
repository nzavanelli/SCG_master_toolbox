function [RR, RR_t, filt] = findRR (scg, t, fs)

filt = [];

cutoff = [0.2, 0.5];
[bh, ah] = butter(1, cutoff*2/fs, 'bandpass');
filt = filtfilt(bh, ah, scg);

finish = t(end)-1;

dist = (60 *fs)/25;

peaks = findpeaks(filt, 'MinPeakDistance', dist);

av = mean(peaks);

RR=[]; RR_t= 30: finish-1;
for i = 30 :finish-1;
t1=(i-29).*fs; t2=i.*fs;

sample = filt(t1:t2);

peaks = findpeaks(sample,'MinPeakDistance', dist, 'MinPeakHeight', av./80);

sampleTime = length(sample)./fs;

temp = (length(peaks))./(sampleTime).*60;
RR = [RR, temp];
end