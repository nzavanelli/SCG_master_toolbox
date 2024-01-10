function [Ms,AO,IVC,AO_magn,IVC_magn] = select_systolic_scg(M,std_threshold)
% *** Select cardiac cycles with a notable systolic complex (based on StD)
% IN
%     - M : M x N matrix of cardiac cycles (N = # cycles of max length M)
%     - std_threshold : minimum StDev that would denote systolic event
% OUT
%     - Ms : M x S matrix of select-length cycles
%     - AO : aortic valve opening timing (ref. to beginning of cycle, likely R peak)
%     - IVC : isovolumetric contraction moment timing (ref. to beginning of cycle, likely R peak)
%     - AO_magn : magnitude of AO point
%     - IVC_magn : magnitude of ICP point

if nargin < 2
    std_threshold = 6e3;   % minimum StDev that would denote systole
end
std_window = 30;        % window size for moving StDev calculation
ix_latest_sys = 200;    % only look for systole until this sample
ix_earliest_sys = 40;    % only look for systole after this sample

ncycs = size(M,2);
keepers = [];

for i = 1:ncycs
    sig = M(:,i);
    notNaN = ~isnan(sig);
    sig = sig(notNaN);
    mstd = movstd(sig,std_window);
    
    gt = mstd > std_threshold;  % trip the sd threshold
    ix_gt = find(gt);
    ix_gt_sys = ix_gt(ix_gt > ix_earliest_sys & ix_gt < ix_latest_sys);  % trip it after & before a certain time
%     ix_gt_sys = ix_gt(ix_gt < ix_latest_sys);  % trip it before a certain time
    gt_sys = sig(ix_gt_sys);
    
    if length(gt_sys) > 2
        top = findpeaks(gt_sys);
        bot = findpeaks(-gt_sys);
    else
        top = [];
        bot = [];
    end
    
    if (sum(ix_gt_sys) > 1)
        keepers = [keepers, i];        
        if ~isempty(top)
            AO_magn(i) = max(top);
            AO(i) = find(sig == AO_magn(i));            
        else
            AO(i) = NaN;
            AO_magn(i) = NaN;
        end
        if ~isempty(bot)
            IVC_magn(i) = -max(bot);
            IVC(i) = find(sig == IVC_magn(i));
        else
            IVC(i) = NaN;
            IVC_magn(i) = NaN;
        end
    else
        AO(i) = NaN;
        AO_magn(i) = NaN;
        IVC(i) = NaN;
        IVC_magn(i) = NaN;
    end
end

Ms = M(:,keepers);

end