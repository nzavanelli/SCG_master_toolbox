function [med,dev] = ens_med_mat(M,plotOn)

med = median(M,2,'omitnan');
% dev = mad(M,1,2);
dev = iqr(M,2);
ind = ~isnan(med);
med = med(ind);
dev = dev(ind);

if plotOn
    figure; 
    hold on;
    plot(med,'color',[0 0 0],'linewidth',2);
    plotFillAlpha(1:length(med),med,dev,[0 0 0],0.25);
end

end