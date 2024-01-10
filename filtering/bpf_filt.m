function Hd = bpf_filt(Fs,Fstop1,Fpass1,Fpass2,Fstop2)
%BPF_PHALANX Returns a discrete-time filter object.
% Generated by MATLAB(R) 9.3 and Signal Processing Toolbox 7.5.
% Generated on: 01-Oct-2018 15:57:41
% Equiripple Bandpass filter designed using the FIRPM function.
% All frequency values are in Hz.

if nargin<1
    Fs = 50000;         % Sampling Frequency
    Fstop1 = 250;       % First Stopband Frequency
    Fpass1 = 750;       % First Passband Frequency
    Fpass2 = 2500;      % Second Passband Frequency
    Fstop2 = 3000;      % Second Stopband Frequency
end

Dstop1 = 0.001;           % First Stopband Attenuation
Dpass  = 0.057501127785;  % Passband Ripple
Dstop2 = 0.0001;          % Second Stopband Attenuation
dens   = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 1 ...
                          0], [Dstop1 Dpass Dstop2]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]