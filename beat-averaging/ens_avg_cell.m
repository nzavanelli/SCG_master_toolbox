function [ens] = ens_avg_cell(cycleCell,plotOn)
% Compute power spectral density estimate using Welch's method for each gait cycle
% INPUT:
%   - cycleCell : 1xN cell, N = # cycles, cycleCell{i} = ith cycle waveform
%   - - e.g., {fx.pitch_filt} where fx = output from gait_cycle_audio
% OUTPUT:
%   - ens : ensemble average PSD across strides

if nargin<2
    plotOn = 0;
end

if isrow(cycleCell{1})
    for i = 1:length(cycleCell)
        cycleCell{i} = cycleCell{i}';
    end
end

nChan = size(cycleCell{1},2);

% Time warp
for i = 1:length(cycleCell)
    len(i) = length(cycleCell{i});
end 
len_mu = round(mean(len));
pct_mu = linspace(0,100,len_mu);
sig_rs = [];
for i = 1:length(cycleCell)
    sig_rs = cat(3,sig_rs,resample(cycleCell{i},len_mu,len(i)));
end 

% ENSEMBLE AVG
% sig_mu = mean(sig_rs,3);
% sig_sd = std(sig_rs,[],3);
sig_mu = nanmean(sig_rs,3);
sig_sd = nanstd(sig_rs,[],3);
ens.pct = pct_mu;
ens.mu = sig_mu;
ens.sd = sig_sd;

%% PLOT
if plotOn
%     figure;
    hold on;
    co = lines;
    flyaways = 0.95;
    alphaval = 0.25;
    for chan = 1:nChan
        for i = 1:length(cycleCell)
            pct_cyc = linspace(0,100,length(cycleCell{i}(:,chan)));
            plot(pct_cyc,cycleCell{i}(:,chan),'color',flyaways*[1 1 1],'linewidth',0.1);
        end
        plot(pct_mu,sig_mu(:,chan),'color',co(chan,:),'linewidth',2);
%         h(chan) = plotFill(pct_mu,sig_mu(:,chan),sig_sd(:,chan),co(chan,:));
%         alpha(h(chan),alphaval);
        h(chan) = plotFillAlpha(pct_mu,sig_mu(:,chan),sig_sd(:,chan),co(chan,:),alphaval);
    end
    xlim([pct_mu(1) pct_mu(end)]);
    xlabel('% cycle');
    ylabel('Signal value');
else
    % nuddin'
end

end


