function [pct,pow,inband] = power_in_band(frq,psd,band,scale)
% *** Compute the power contained in a frequency band, given an input PSD
% IN
%     - frq : Nx1 vector of PSD frequencies (EG, output of compute_fft.m)
%     - psd : Nx1 vector of PSD powers (EG, output of compute_fft.m)
%     - band : frequency band of interest ([x y])
%         - entering a single value defines the end of 'frq' as the upperbound
%     - scale : how to scale the input powers
%         - 'linear' (default) : simply uses the input 'psd'
%         - 'log' : converts powers to dB
%         - 'norm1hz' : normalizes powers to the value at 1 Hz
% OUT
%     - pct : % total power in band ([0 1])

if nargin < 4
    scale = 'linear';
end

if length(band) == 1
    flo = band(1);
    fhi = frq(end);
elseif length(band) == 2 
    flo = band(1);
    fhi = band(2);
end

[~,i_frq_lo] = min(abs(frq-flo));
[~,i_frq_hi] = min(abs(frq-fhi));
inband = i_frq_lo:i_frq_hi;

switch scale
    case 'linear'
        % use input 'psd'
    case 'log'
        psd = 10*log10(psd);
    case 'norm1hz'
        [~,i_frq_1hz] = min(abs(frq-1));
        psd = psd ./ psd(i_frq_1hz);
end

psd_inband = psd(inband);

Ptot = trapz(psd);
Pband = trapz(psd_inband);

pct = Pband ./ Ptot;
pow = Pband;
end
