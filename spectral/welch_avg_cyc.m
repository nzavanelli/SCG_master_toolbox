function [wm_mu] = welch_avg_cyc(fx,plotOn)
% Compute power spectral density estimate using Welch's method for each gait cycle
% INPUT:
%   - fxx : output of gait_cycle_audio ('wm' struct for # of gait cycles)
% OUTPUT:
%   - wm_mu : ensemble average PSD across strides

if nargin<2
    plotOn = 0;
end

% Time warp
for i = 1:length(fx)
    frqlen(i) = numel(fx(i).wm.frq);
end 
frqlen_mean = round(mean(frqlen));
frq_rs = [];
pxx_dB_rs = [];
pxx_dB_rmsnorm_rs = [];

for i = 1:length(fx)
    frq_rs = cat(3,frq_rs,resample(fx(i).wm.frq,frqlen_mean,frqlen(i)));
    pxx_dB_rs = cat(3,pxx_dB_rs,resample(fx(i).wm.pxx_dB,frqlen_mean,frqlen(i)));
    pxx_dB_rmsnorm_rs = cat(3,pxx_dB_rmsnorm_rs,resample(fx(i).wm.pxx_dB_rmsnorm,frqlen_mean,frqlen(i)));
end 

% ENSEMBLE AVG
frq_mu = mean(frq_rs,3);
frq_sd = std(frq_rs,[],3);
pxx_dB_mu = mean(pxx_dB_rs,3);
pxx_dB_sd = std(pxx_dB_rs,[],3);
pxx_dB_rmsnorm_mu = mean(pxx_dB_rmsnorm_rs,3);
pxx_dB_rmsnorm_sd = std(pxx_dB_rmsnorm_rs,[],3);    
wm_mu.frq_mu = frq_mu;
wm_mu.frq_sd = frq_sd;
wm_mu.pxx_dB_mu = pxx_dB_mu;
wm_mu.pxx_dB_sd = pxx_dB_sd;
wm_mu.pxx_dB_rmsnorm_mu = pxx_dB_rmsnorm_mu;
wm_mu.pxx_dB_rmsnorm_sd = pxx_dB_rmsnorm_sd;

% PLOT
nmics = size(fx(1).wm.pxx,2);

if plotOn
    figure;
    hold on;
    co = lines;
%     for i = 1:length(fx)
%         plot(fx(i).wm.frq,fx(i).wm.pxx_dB(:,1),'color',0.9*[1 1 1],'linewidth',0.1);
%         plot(fx(i).wm.frq,fx(i).wm.pxx_dB(:,2),'color',0.9*[1 1 1],'linewidth',0.1);
%         plot(fx(i).wm.frq,fx(i).wm.pxx_dB(:,3),'color',0.9*[1 1 1],'linewidth',0.1);
%     end
% 
%     plot(frq_mu,pxx_dB_mu(:,1),'color',co(1,:),'linewidth',2);
%     h1 = plotFill(frq_mu,pxx_dB_mu(:,1),pxx_dB_sd(:,1),co(1,:)); 
%     alpha(h1,0.25);
%     plot(frq_mu,pxx_dB_mu(:,2),'color',co(2,:),'linewidth',2);
%     h2 = plotFill(frq_mu,pxx_dB_mu(:,2),pxx_dB_sd(:,2),co(2,:));
%     alpha(h2,0.25);
%     plot(frq_mu,pxx_dB_mu(:,3),'color',co(3,:),'linewidth',2);
%     h3 = plotFill(frq_mu,pxx_dB_mu(:,3),pxx_dB_sd(:,3),co(3,:));
%     alpha(h3,0.25);  
    
    for i = 1:length(fx)
        for mic = 1:nmics
            plot(fx(i).wm.frq,fx(i).wm.pxx_dB(:,mic),'color',0.9*[1 1 1],'linewidth',0.1);
        end
    end

    for mic = 1:nmics
        plot(frq_mu,pxx_dB_mu(:,mic),'color',co(mic,:),'linewidth',2);
        h(mic) = plotFill(frq_mu,pxx_dB_mu(:,mic),pxx_dB_sd(:,mic),co(mic,:)); 
        alpha(h(mic),0.25);
    end
    
    xlim([100 1e4]);
%     xlim([30 1000]);
    set(gca,'xscale','log');
    xlabel('Log Frequency (Hz)');
    ylabel('PSD (dB/Hz)');
else
    % nuddin'
end
end


