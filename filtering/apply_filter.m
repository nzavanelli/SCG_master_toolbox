function [Xf,grpdel] = apply_filter(X,cutoffs,fs,filtype)
% INPUT
% - X : raw acceleration signal
% - cutoffs : row vector of bandpass parameters (pass/stopband cutoffs)
% -- of the form [lostop lopass hipass histop]
% - fs : sampling rate (Hz)
% OUTPUT
% - Xf : filtered signal

if nargin < 4
    filtype = 'bpf';
end

switch filtype
    case 'bpf'
        lostop  = cutoffs(1);
        lopass  = cutoffs(2);
        hipass  = cutoffs(3);
        histop  = cutoffs(4);
        fil     = bpf_filt_kaiser(fs,lostop,lopass,hipass,histop);
    case 'lpf'
        lostop  = cutoffs(2);
        lopass  = cutoffs(1);
        fil     = lpf_filt(fs,lopass,lostop);
end
filnum  = fil.Numerator;

% MULTI-COLUMN X
ncols = size(X,2);
Xf = zeros(size(X));    % pre-allocate
for col = 1:ncols
    Xf_tmp = conv(filnum,X(:,col));
    Xf(:,col) = Xf_tmp(1:end-numel(filnum)+1); % trim trailing values added by 'conv'
end

% GROUP DELAY 
grpdel = mode(grpdelay(fil));

end