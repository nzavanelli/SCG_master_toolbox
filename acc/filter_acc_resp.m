function [acc_f] = filter_acc_resp(acc,fs,cutoff,plotOn)
% *** Filter accelerometer signal to get coarse tidal movements of chest
% IN
%     - acc : Mx1 vector of accelerometer signal
%     - fs : sampling rate (Hz)
%     - plotOn : plot result (1) or not (0)
% OUT
%     - acc_f : Mx1 vector of filtered SCG signal

if nargin < 3
    cutoff = 1;
    plotOn = 0;
end
iir_order = 7;
iir = designfilt('lowpassiir','filterorder',iir_order,...
    'halfpowerfrequency',cutoff,'samplerate',fs);
acc_f = filtfilt(iir,acc);

if plotOn
    figure;
    hold on;
%     yyaxis left;
    plot(acc);
%     yyaxis right;
    plot(acc_f,'linewidth',2);
end

end 