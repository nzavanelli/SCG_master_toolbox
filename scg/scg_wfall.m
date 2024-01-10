function [scg_reform] = scg_wfall(ac_f, SCGar,Fs, plotOn, cutout1, cutout2)
% creates a waterfall plot for the selected data period
% the cutouts show how a particular feature in the SCG signal evolves with
% each beat

scg_mat = SCGar;

scg_reform = [];
for j = 1:length(scg_mat(1,:))
    seg = scg_mat(:,j);
    flag = 0;
    for i = 1:length(seg)
        if(seg(i) > 0.010)
            flag = 1;
        end
    end
    if (flag == 0)
        scg_reform = [scg_reform, seg];
    end
end


axis1 = scg_mat(cutout1,:);
axis1 = smoothdata(axis1,'Gaussian',100);
figure
plot(axis1, 'color',[3./255, 139./255,67./255], 'Linewidth', 4)
set(gcf,'color','w');
set(gca,'FontSize',10);

axis2 = scg_mat(cutout2,:);
axis2 = smoothdata(axis2,'Gaussian',150);
figure
plot(axis2, 'color',[230./255, 0./255,255./255], 'Linewidth', 3)
set(gcf,'color','w');
set(gca,'FontSize',10);

if(plotOn)
    figure
    waterfall(scg_reform)
    set(gcf,'color','w');
    set(gca,'FontSize',10);
    colorbar
end

end