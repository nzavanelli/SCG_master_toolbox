function [lbl] = label_scg(SCG,fs,s1win,s2win,plotOn)

ncycs = size(SCG,2);
for cyc = 1:size(SCG,2)
    scg_beat = SCG(:,cyc);
%     t_beat{cyc} = sum(~isnan(scg_beat)) / fs;
    X{cyc,1} = get_scg_extrema(scg_beat,fs,[],0,0,0);
    [ao(cyc,1),aom(cyc,1),mc(cyc,1),mcm(cyc,1),ic(cyc,1),icm(cyc,1)] = ...
        tag_scg_extrema_s1(X{cyc,1},s1win,'ao','amp');
    [ac(cyc,1),acm(cyc,1),ir(cyc,1),irm(cyc,1),mo(cyc,1),mom(cyc,1)] = ...
        tag_scg_extrema_s2(X{cyc,1},s2win,'ir','prom');
end

rr = sum(~isnan(SCG))' / fs;
L = [mc mcm ic icm ao aom ac acm ir irm mo mom rr];
lbl = array2table(L);
lbl.Properties.VariableNames = {'mc','mcm','ic','icm','ao','aom','ac','acm','ir','irm','mo','mom','rr'};

%% Nathan added 4/5/21

% AO = zeros(length(lbl.ao),1);
% 
% for k = 1:length(AO)
%     sig = SCG(:,k);
%     seg = sig(36:51);
%     peak = max(seg);
%     [x,y] = find(seg == peak);
%     loc = (x+36)./500;
%     lbl.ao(k) = loc;
%     lbl.aom(k) = peak;
% end

%% 

if plotOn 
    figure 
      hold on;
    co = lines;
    alpha = 0.1;
    p1 = plot(SCG,'color',[0 0 0 alpha]);
    for cyc = 1:length(p1)
        set(get(get(p1(cyc),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    end 
    scatter(lbl.mc*fs,lbl.mcm,25,co(1,:),'filled','markerfacealpha',0.3);
    scatter(lbl.ic*fs,lbl.icm,25,co(2,:),'filled','markerfacealpha',0.3);
    scatter(lbl.ao*fs,lbl.aom,25,co(3,:),'filled','markerfacealpha',0.3);
    scatter(lbl.ac*fs,lbl.acm,25,co(4,:),'filled','markerfacealpha',0.3);
    scatter(lbl.ir*fs,lbl.irm,25,co(5,:),'filled','markerfacealpha',0.3);
    scatter(lbl.mo*fs,lbl.mom,25,co(6,:),'filled','markerfacealpha',0.3);
    legend('mc','ic','ao','ac','ir','mo');
    legend('boxoff');
    xlabel('Time (samples)');
    title('SCG Overlay');
    
    figure;
    
    subplot(311);
    hold on;
    co = lines;
    alpha = 0.1;
    p1 = plot(SCG,'color',[0 0 0 alpha]);
    for cyc = 1:length(p1)
        set(get(get(p1(cyc),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    end 
    scatter(lbl.mc*fs,lbl.mcm,25,co(1,:),'filled','markerfacealpha',0.3);
    scatter(lbl.ic*fs,lbl.icm,25,co(2,:),'filled','markerfacealpha',0.3);
    scatter(lbl.ao*fs,lbl.aom,25,co(3,:),'filled','markerfacealpha',0.3);
    scatter(lbl.ac*fs,lbl.acm,25,co(4,:),'filled','markerfacealpha',0.3);
    scatter(lbl.ir*fs,lbl.irm,25,co(5,:),'filled','markerfacealpha',0.3);
    scatter(lbl.mo*fs,lbl.mom,25,co(6,:),'filled','markerfacealpha',0.3);
    legend('mc','ic','ao','ac','ir','mo');
    legend('boxoff');
    xlabel('Time (samples)');
    title('SCG Overlay');
    
    sp(1) = subplot(312);
    hold on;
    plot(lbl.mc,'color',co(1,:));
    plot(lbl.ic,'color',co(2,:));
    plot(lbl.ao,'color',co(3,:));
    plot(lbl.ac,'color',co(4,:));
    plot(lbl.ir,'color',co(5,:));
    plot(lbl.mo,'color',co(6,:));
    leg = legend('mc','ic','ao','ac','ir','mo');
    leg.ItemHitFcn = @interactiveLegend;
    legend('boxoff');
    xlabel('Beat #')
    title('Fiducial Marker Timing (s)');
    
    sp(2) = subplot(313);
    hold on;
    plot(lbl.mcm,'color',co(1,:));
    plot(lbl.icm,'color',co(2,:));
    plot(lbl.aom,'color',co(3,:));
    plot(lbl.acm,'color',co(4,:));
    plot(lbl.irm,'color',co(5,:));
    plot(lbl.mom,'color',co(6,:));
    leg = legend('mc','ic','ao','ac','ir','mo');
    leg.ItemHitFcn = @interactiveLegend;
    legend('boxoff');
    xlabel('Beat #');
    title('Fiducial Marker Magnitude');
    
    linkaxes(sp,'x');
end



end