function pos = get_sleep_position(x,y,z,plotOn)

v = [x y z];
u = get_unit_vector(v);
ux = u(:,1);
uy = u(:,2);
uz = u(:,3);

parallel = 0.75;
supine = uz > parallel;
prone = uz < -parallel*0.5;
lli = ux > parallel;
rli = ux < -parallel;
upright = uy < -parallel & uz > -parallel*0.25;

pos = zeros(length(v),1);
pos(supine) = 1;
pos(prone) = 2;
pos(upright) = 3;
pos(lli) = 4;
pos(rli) = 5;

pos_supine = pos;
pos_supine(pos_supine ~= 1) = NaN;
pos_prone = pos;
pos_prone(pos_prone ~= 2) = NaN;
pos_upright = pos;
pos_upright(pos_upright ~= 3) = NaN;
pos_lli = pos;
pos_lli(pos_lli ~= 4) = NaN;
pos_rli = pos;
pos_rli(pos_rli ~= 5) = NaN;

if plotOn
    co = lines;
    figure;
    hold on;
    plot(pos_supine,'linewidth',2,'color',co(1,:));
    plot(pos_prone,'linewidth',2,'color',co(2,:));
    plot(pos_upright,'linewidth',2,'color',co(4,:));
    plot(pos_lli,'linewidth',2,'color',co(5,:));
    plot(pos_rli,'linewidth',2,'color',co(6,:));
    legend('supine','prone','upright','lt-lat-incumbent','rt-lat-incumbent')
    ylim([0 6])
end 
end