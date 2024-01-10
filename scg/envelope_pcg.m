function [Me,MC] = envelope_pcg(M,plotOn)
% *** Generate amplitude envelope of PCG signal for mitral valve closure
% detection (MC)
% IN
%     - M : M x N matrix of cardiac cycles (N = # cycles of max length M)
%         * NB -> should be pre-filtered to contain only heart sounds!
%     - fs : sampling rate (Hz)
% OUT
%     - Me : M x S matrix of enveloped signals

envelope_method = 'peak';
envelope_factor = 5;
ix_earliest_sys = 20;   % only look for systole after this sample
ix_latest_sys = 150;    % only look for systole until this sample

ncycs = size(M,2);
Me = NaN*ones(size(M));
for i = 1:ncycs
    notNaN = ~isnan(M(:,i));
    sig = M(notNaN,i);
    env = envelope_nbb(sig,envelope_factor,envelope_method);
    Me(1:length(env),i) = env;
    [~,MC(i)] = max(env(ix_earliest_sys:ix_latest_sys));
    MC(i) = MC(i) + ix_earliest_sys;
end 

if plotOn
    ens_avg_mat(Me,plotOn);
end

end



