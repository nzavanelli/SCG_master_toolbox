function [M_avg,tref_avg,beats_used] = avg_beat_interval(X,tref,fs,twin,overlap,plotOn)
% *** Compute time interval-based moving ensemble average of cardiac signal
% IN
%     - X : column or row vector of full signal time series
%     - tref : vector of timing references for segmenting beats (s)
%     - fs : sampling rate of X (Hz)
%     - twin : time window in which to average beats (s)
%     - overlap : percent shared between successive trames ([0 1])
%     - plotOn : plot result (1) or not (0)
% OUT
%     - M_avg : PxQ array of ensemble averaged beats (P = max length, Q = # average beats)
%     - tref_avg : 1xQ vector timing references marking the start of each average beat 
%     - beats_used : 1xQ vector describing # of beats averaged within each window

if nargin < 6
    plotOn = 0;
end

time = (1:length(X)) / fs;
iref = round(tref * fs);
iwin = round(twin * fs);
ishift = round(twin * (1 - overlap) * fs);
len = length(X);

i1 = 1;
incr = 1;

while i1 < (len-iwin)
    i2 = i1 + iwin;
    frame = i1:i2;
    inframe = iref >= i1 & iref < i2;
    tref_inframe = tref(inframe);
    tref_inframe = tref_inframe - ((i1-1)/fs);
    beats_used(incr) = length(tref_inframe);
    snippet = X(frame);
%     snippet_exp = [];   % TODO -> exponentially weight snippet to make recent signal more important
    
    if beats_used(incr) < 2     % might be because frame is too short or no trefs are recognized in frame
        M_snippet = NaN*ones(length(frame),1);
        beats_used(incr) = 0;
    else
        [~,M_snippet] = segment_cycles(snippet,tref_inframe,fs,0);
    end
    [mu{incr},sd{incr}] = ens_avg_mat(M_snippet,0);
    tref_avg(incr) = (i1-1) / fs;
    
    % Increment loop variables
    i1 = i1 + ishift;
    incr = incr + 1;
end

% END-OF-TRIAL CONDITION
while (i1 > (length(X)-iwin)) && (i1 < len)
    i2 = len;
    frame = i1:i2;
    inframe = iref >= i1 & iref < i2;
    tref_inframe = tref(inframe);
    tref_inframe = tref_inframe - ((i1-1)/fs);
    beats_used(incr) = length(tref_inframe);
    snippet = X(frame);
%     snippet_exp = [];   % TODO -> exponentially weight snippet to make recent signal more important
    
    if beats_used(incr) < 2     % might be because frame is too short or no trefs are recognized in frame
        M_snippet = NaN*ones(length(frame),1);
        beats_used(incr) = 0;
    else
        [~,M_snippet] = segment_cycles(snippet,tref_inframe,fs,0);
    end
    [mu{incr},sd{incr}] = ens_avg_mat(M_snippet,0);
    tref_avg(incr) = (i1-1) / fs;
    
    % Increment loop variables
    i1 = i1 + ishift;
    incr = incr + 1;
end

% CONCATENATE ALL AVERAGE BEATS
M_avg = padcat(mu{:});
% SD_avg = padcat(sd{:});

% REMOVE COLUMNS AND ROWS THAT ARE EXCLUSIVELY NAN's
nancols = all(isnan(M_avg),1);
nanrows = all(isnan(M_avg),2);
M_avg(:,nancols) = [];
M_avg(nanrows,:) = [];

if length(tref_avg) - size(M_avg,2) == 1
    M_avg = [M_avg M_avg(:,end)];
end
    
if plotOn
    figure;
    hold on;
    alpha = 0.1;
    tt = (1:size(M_avg,1))/fs;
    p1 = plot(tt,M_avg);
    set(p1(:),'Color',[0 0 0 alpha]);
    xlabel('Time (s)');
end 

end