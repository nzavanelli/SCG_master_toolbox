function [C] = get_cardiodicity(x,fs)

f_cardio = [0.5 2.5];
[c,lags] = xcorr(x,'normalized');

lags_cardio = f_cardio * fs;
inband = lags > min(lags_cardio) & lags < max(lags_cardio);
lags_inband = lags(inband);
c_inband = c(inband);

c_inband_max = max(c_inband);

C = c_inband_max;
end