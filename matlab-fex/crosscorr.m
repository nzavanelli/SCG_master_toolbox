function [coeff] = crosscorr(x1,x2,fs)

[c,lag] = xcorr(x1,x2,'coeff');
[c_max,c_max_i] = max(c);
lag_c_max = lag(c_max_i);
c_0 = c(lag==0);
coeff.c = c;
coeff.lag = lag;
coeff.cMax = c_max;
coeff.cMax_lag = lag_c_max;
coeff.c0 = c_0;

%% Display
plot(lag/fs,c);
grid on
xlabel('Lag Time (s)')
ylabel('Amplitude (norm)')
title('Correlation Coefficient')

end