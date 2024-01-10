
function [beatAvs] = diff_array(meanTemplate,ac_f, SCGar, Fs, thold)
% Create beat arrays for each 30s window
scg_rev = ac_f.*-1;
%findpeaks(scg_rev, 'MinPeakDistance', fs-fs/5)

[pks, locs] = findpeaks(scg_rev, 'MinPeakDistance', Fs-Fs/5);

locs_s = locs./Fs; %Get the pk locations in seconds

beatAvs = [];
energy = rms(meanTemplate);

for s = 1:(length(ac_f)./(250.*2))-5
    seg = [];
    for j = 1:length(locs_s)
        if (locs_s(j) > (s.*2)-2 & locs_s(j) < (2.*s)+2)
            temp = SCGar(:,j);
            if(rms(temp)< thold.*energy)
                seg = [seg, temp];
            end
        end
    end
    beat = mean(seg,2, 'omitnan');
    beat = beat(1:230);
    beatAvs = [beatAvs, beat];
end