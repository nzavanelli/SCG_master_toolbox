function [scg_f] = filter_scg(scg,fs,band,plotOn)
% *** Filter SCG signal
% IN
%     - scg : Mx1 vector of SCG signal
%     - fs : sampling rate (Hz)
%     - band : passband for filter ([Fstop1 Fstop2])
%     - plotOn : plot result (1) or not (0)
% OUT
%     - scg_f : Mx1 vector of filtered SCG signal
    
if nargin < 3
    Fstop1 = 10;
    Fstop2 = 25;
    plotOn = 0;
else
    Fstop1 = band(1);
    Fstop2 = band(2);
end

iir_order = 10;
iir = designfilt('bandpassiir','FilterOrder',iir_order, ...
        'HalfPowerFrequency1',Fstop1,'HalfPowerFrequency2',Fstop2, ...
        'SampleRate',fs);
scg_f = filtfilt(iir,scg);

if plotOn
    figure;
    hold on;
    yyaxis left;
    plot(scg);
    yyaxis right;
    plot(scg_f);
end

end 