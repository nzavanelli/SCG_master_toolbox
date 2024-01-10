function [meanSCG, sdSCG, SCGar, t] = segment_scg(ac_f, fs, plotON)

%invert the signal to segment based on the gross acceleration during
%ejection
scg_rev = ac_f.*-1;
%findpeaks(scg_rev, 'MinPeakDistance', fs-fs/5)

[pks, locs] = findpeaks(scg_rev, 'MinPeakDistance', fs-fs/5);
SCGar = [];

%create an array of beats
for i = 2:length(pks)-1
    SCGtemp = ac_f(locs(i)-(fs/2-5):locs(i)+(fs/2-5));
    SCGar = [SCGar , SCGtemp];
end

%plot ecah beat on top of the others
if(plotON)
    figure
    title('IR Segmented Signal')
    xlabel('Time (s)')
    ylabel('AU')
    set(gca,'FontSize',20)


    for i = 1:length(SCGar(1,:))
        tempSCG = SCGar(:,i);
        t =(1:length(tempSCG))./fs;
        p1 = plot(t, tempSCG, 'b', 'Linewidth', 0.5);
        pl.Color(4) = 0.25;
        hold on
    end
end

%prepare the data for export
meanSCG = mean(SCGar,2, 'omitnan');
sdSCG = std(SCGar,0,2, 'omitnan');

meanSCG = meanSCG(1:fs-20);
sdSCG = sdSCG(1:fs-20);
t = (1:fs-20)./((fs*4)./5);