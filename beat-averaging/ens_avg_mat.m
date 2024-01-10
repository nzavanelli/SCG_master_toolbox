function [mu,sd] = ens_avg_mat(M,plotOn)

mu = nanmean(M,2);
sd = nanstd(M,[],2);
ind = ~isnan(mu);
mu = mu(ind);
sd = sd(ind);

if plotOn
    figure; 
    hold on;
    plot(mu,'color',[0 0 0],'linewidth',2);
    plotFillAlpha(1:length(mu),mu,sd,[0 0 0],0.25);
end

end