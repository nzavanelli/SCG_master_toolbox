function [meanTemplate] = gen_template(ac_f, SCGar,Fs, plotOn)

% Template beat generation
scg_rev = ac_f.*-1;
%findpeaks(scg_rev, 'MinPeakDistance', fs-fs/5)

[pks, locs] = findpeaks(scg_rev, 'MinPeakDistance', Fs-Fs/5);

locs_s = locs./Fs; %Get the pk locations in seconds

template = []; %define a template beat to learn the average heartbeat during rest

for k = 1:length(locs_s)
    if (locs_s(k) > 1 & locs_s(k) < 10)
        template = [template , SCGar(:,k)];
    end
end

meanTemplate = mean(template,2, 'omitnan');
meanTemplate = meanTemplate(1:230);
t = (1:230)./200;

if (plotOn)
    figure
    plot(t,meanTemplate,'b');
    xlabel('Time (s)')
    ylabel('AU')
    title('Template Beat')
    set(gcf,'color','w');
    set(gca,'FontSize',10);
    box on;
end

end