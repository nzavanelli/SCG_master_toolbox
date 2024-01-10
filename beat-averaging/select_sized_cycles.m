function [Ms,keep,toss] = select_sized_cycles(M,sigma,plotOn)
% *** Reject cardiac cycles that are too long or too short
% IN
%     - M : M x N matrix of cardiac cycles (N = # cycles of max length M)
%     - sigma : # st devs away from average length to keep
%     - plotOn : plot result (1) or not (0)
% OUT
%     - Ms : M x S matrix of select-length cycles


if nargin < 2
    sigma = 2;
    plotOn = 0;
end 

ncycs = size(M,2);
for i = 1:ncycs
    len(i) = sum(~isnan(M(:,i)));
end

len_avg = mean(len);
len_med = median(len);
len_std = std(len);
len_lo = len_med - sigma*len_std;
len_hi = len_med + sigma*len_std;

keep = len > len_lo & len < len_hi;
toss = ~keep;
Ms = M(:,keep);

full = 1:ncycs;
keep = full(keep);
toss = full(toss);

if plotOn
    ens_avg_mat(Ms,plotOn);
end
end