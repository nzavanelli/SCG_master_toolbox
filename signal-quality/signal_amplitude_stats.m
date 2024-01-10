function [amp] = signal_amplitude_stats(sig)
% *** Compute a standard set of amplitude-based features of a signal
% IN
%     sig : 1xN vector (may contain NaN, which will be removed)
% OUT
%     amp : table (or possibly struct) containing stats
    
signan = isnan(sig);
sig(signan) = [];

amp.mean        = mean(sig);
amp.med         = median(sig);
amp.mode        = mode(sig);
amp.rms         = rms(sig);
amp.min         = min(sig);
amp.max         = max(sig);
amp.range       = range(sig);
amp.mad         = mad(sig);     % mean absolute deviation
amp.std         = std(sig);
amp.var         = var(sig);
amp.iqr         = iqr(sig);     % interquartile range
amp.rssq        = rssq(sig);   % root sum squared
amp.peak2rms    = peak2rms(sig);   % peak-to-rms ratio
amp.sum         = sum(sig);
amp.trapz       = trapz(sig);

amp = struct2table(amp);
end