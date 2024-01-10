function [accpc,varex] = get_acc_pca(x,y,z,npcs,plotOn)
% *** Determine principal components of accel data to determine direction
% of maximal variance
% IN
%     - x,y,z : 1xN vectors of accel data
%     - npcs : # of principal components to include
%     - plotOn : plot result (1) or not (0)
% OUT
%     - accpc : accel data projected onto principal axis (axes)
%     - varex : pct variance in accel signals explained by PCs

acc = [x y z];
[coeff,score,~,~,explained,~] = pca(acc);
accpc = sum(score(:,1:npcs),2);
varex = sum(explained(1:npcs));

if plotOn
    figure;
    hold on;
    plot(acc);
    plot(accpc);
    legend('x','y','z','pc');
    legend('boxoff');
end
end
