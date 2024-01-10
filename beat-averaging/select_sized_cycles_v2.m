function [Ms,keep,toss] = select_sized_cycles_v2(M,fs,ibi_min,ibi_max,plotOn)
% *** Reject cardiac cycles that are too long or too short
% IN
%     - M : M x N matrix of cardiac cycles (N = # cycles of max length M)
%     - sigma : # st devs away from average length to keep
%     - plotOn : plot result (1) or not (0)
% OUT
%     - Ms : M x S matrix of select-length cycles


ncycs = size(M,2);
icycs = 1:ncycs;
for i = 1:ncycs
    len(i) = sum(~isnan(M(:,i)));
end

ibi = len / fs; % inter-beat intervals

% REJECT CYCLES THAT ARE TOO SHORT
tooshort = ibi < ibi_min;

% REJECT CYCLES THAT ARE TOO LONG
toolong = ibi > ibi_max;

% REJECT CYCLES IN WHICH HEART RATE CHANGES UNFEASIBLY QUICKLY
d_max = 0.5;
d_ibi = [diff(ibi) 0];
toofast = d_ibi > d_max | d_ibi < -d_max;


% toss = tooshort | toolong;
toss = tooshort | toolong | toofast;
keep = ~toss;
Ms = M(:,keep);
toss = icycs(toss);
keep = icycs(keep);

if plotOn
    ens_avg_mat(Ms,plotOn);
end

end