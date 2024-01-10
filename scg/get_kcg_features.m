function [kcg] = get_kcg_features(acc,tref,fs,twin)

scg_band = [3 20];
mass = 1;   % N

if size(acc,2) > 1
    accn = sqrt(sum(acc.^2,2));
else
    accn = acc;
end

scg         = filter_scg(accn,fs,scg_band,0);
[~,scg_mat] = segment_cycles(scg,tref,fs,0);
if isempty(twin)
    frame = 1:size(scg_mat,1);
else
    if twin(1) == 0
        frame = 1 : twin(2)*fs;
    else
        frame = (twin(1)*fs) : (twin(2)*fs);
    end
end

ncycs = size(scg_mat,2);
for cyc = 1:ncycs
    scg_beat = scg_mat(frame,cyc);
    
    vel = cumtrapz(scg_mat(:,cyc));
    
    ke = 0.5 * mass * vel.^2;
    F = mass * scg_beat;
    
    ke_avg = mean(ke,'omitnan');
    ke_std = std(ke,'omitnan');
    H = ke_avg ./ ke_std;
    F_avg = mean(F,'omitnan');
    F_std = std(F,'omitnan');
    
    kcg(cyc,:) = [ke_avg ke_std H F_avg F_std];    
end

end