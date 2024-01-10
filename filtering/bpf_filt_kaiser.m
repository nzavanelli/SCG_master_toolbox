function Hd = bpf_filt_kaiser(fs,Fstop1,Fpass1,Fpass2,Fstop2)
% INPUT
% - fs : sampling rate (Hz)
% - Stopband and passband cutoff frequencies
% OUTPUT
% - Hd : discrete-time filter object (FIR bandpass, Kaiser-window)

% All frequency values are in Hz.
if nargin < 1
    fs = 50000;     % Sampling Frequency
    Fstop1 = 200;   % First Stopband Frequency
    Fpass1 = 300;   % First Passband Frequency
    Fpass2 = 600;   % Second Passband Frequency
    Fstop2 = 750;   % Second Stopband Frequency
end

Dstop1 = 0.001;           % First Stopband Attenuation
Dpass  = 0.057501127785;  % Passband Ripple
Dstop2 = 0.001;           % Second Stopband Attenuation
flag   = 'scale';         % Sampling Flag

% Calculate the order from the parameters using KAISERORD.
[N,Wn,BETA,TYPE] = kaiserord([Fstop1 Fpass1 Fpass2 Fstop2]/(fs/2), [0 ...
                             1 0], [Dstop1 Dpass Dstop2]);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd = dfilt.dffir(b);
