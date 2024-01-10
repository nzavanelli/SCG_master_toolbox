function [acc_ac] = remove_acc_dc(acc,win,fs)
% *** Remove DC component of signal based on some moving window average
% IN
%     - acc : 1xN vector
%     - win : moving average window (s)
%     - fs : sampling rate
% OUT
%     - acc_ac : 1xN vector of AC-only component of signal
  
if length(acc) < win*fs
    warning('Window is longer than the input signal.');
end

% acc_m = movmean(acc,win*fs);
acc_m = movmean(acc,win*fs,'omitnan');
acc_ac = acc - acc_m;

end