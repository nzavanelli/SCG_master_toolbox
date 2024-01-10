%load p.csv first
close all

seg  = red_f(988.*250:998.*250);

sd = 17;
add = sd.*randn(length(seg),1);
out = seg+add;
figure
plot(add)


cutoff = [.8 5]; %BPF for PPG
Fs = 250;
[bh, ah] = butter(3, cutoff*2/Fs, 'bandpass');
seg_f = filtfilt(bh, ah, out);

figure
plot(seg)
hold on
plot(seg_f)
% plot(out)
g = wdenoise(seg_f);
figure
plot(g)