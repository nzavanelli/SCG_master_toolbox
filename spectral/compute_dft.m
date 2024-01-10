function [FFT,frq] = compute_dft(frame,fs)
% This function returns the DFT of a discrete signal and the 
% respective frequency range.
% 
% INPUTS:
%   - signal: vector containing the samples of the signal
%   - Fs:     the sampling frequency
% OUTPUTS:
%   - FFT:    the magnitude of the DFT coefficients
%   - frq:   the corresponding frequencies (in Hz)

N = length(frame);  % length of signal

% compute the magnitude of the spectrum
% (and normalize by the number of samples):
FFT = abs(fft(frame)) / N;
FFT = FFT(1:ceil(N/2));    
frq = (fs/2) * (1:ceil(N/2)) / ceil(N/2);  % define the frequency axis

end