function [C,M] = segment_cycles(X,tref,fs_X,plotOn)
% INPUTS
%     - X : MxN array, M = # samples, N = # channels
%     - tref : vector of timing indices [s]
%     - fs_X : sampling rate of X [Hz]
% OUTPUTS: 
%     - cyc : 1xS struct, S = # cycles, each containing fields
%         cyc.X : mic data split into cycles
%         cyc.pct : linspace(0,100,length(cyc.X))

if nargin<4
    plotOn = 0;
end

ix = tref*fs_X;
nchan = size(X,2);

for j = 1:length(ix)-1
    ix1         = round(ix(j));
    ix2         = round(ix(j+1));
    X_cyc       = X(ix1:ix2,:);
    pct_cyc     = linspace(0,100,length(X_cyc))'; 
    L_cyc(j)    = length(X_cyc);
    C(j).X    = X_cyc;
    C(j).pct  = pct_cyc;
end

M = NaN*ones(max(L_cyc),length(C));

for j = 1:length(C)
    M(1:L_cyc(j),j) = C(j).X;
end

% OVERLAY MIC SIGNALS?
if plotOn
    figure;
    hold on;
    alpha = 0.1;
    tt = (1:size(M,1))/fs_X;
    p1 = plot(tt,M);
    set(p1(:),'Color',[0 0 0 alpha]);
    xlabel('Time (s)');
    
%     for gc = 1:length(C)
%         for chan = 1:nchan
%             sp(chan) = subplot(nchan,1,chan);
%             hold on;
%             plot(C(gc).pct,C(gc).X(:,chan));
%         end
%     end
%     linkaxes(sp,'xy');
end

end