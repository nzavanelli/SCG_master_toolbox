function [X,T] = get_scg_extrema(scg_beat,fs,timeframe,tblout,reject,plotOn)
% *** EXTRACT ALL EXTREMA (PEAKS AND VALLEYS) OF A SINGLE SCG BEAT
% IN
%     - scg_beat : Nx1 vector of SCG in a single heartbeat (or average)
%     - fs : sampling rate (Hz)
%     - timeframe : window in which to extract peaks and valleys (s)
%         [t1 t2] -> looks between these two timepoints
%         [] -> looks across the entire beat
%     - tblout : generate table with labeled columns (1) or not (0)
%     - reject : reject inappropriately sized beats as NaN (1) or not (0)
%     - plotOn : plot results (1) or not (0)
% OUT
%     - X : PxQ array of extrema (P = # peaks/valleys, Q = # descriptors)
%         X(:,1) -> amplitude
%         X(:,2) -> peak index (rel. to sampling rate)
%         X(:,3) -> peak time (s)
%         X(:,4) -> peak width
%         X(:,5) -> peak prominence
%         X(:,6) -> sign of extremum (1 = peak, -1 = valley)
%     - T : table output version of X (if enabled)
        
% DEFINE WORKING SIGNAL
if isrow(scg_beat)
    scg_beat = scg_beat';
end
scg = scg_beat(~isnan(scg_beat));
len = length(scg);
if isempty(timeframe)
    i1 = 1;
    i2 = len;
else
    if timeframe(1) == 0
        i1 = 1;
    else
        i1 = timeframe(1) * fs;
    end
    i2 = timeframe(2) * fs;
end
if i1 > len 
    warning('Start of timeframe is longer than this beat. Starting frame at i=1 instead.');
    i1 = 1;
    toss = true;
end
if i2 > len
    warning('End of timeframe is longer than this beat. Ending frame at signal endpoint instead.');
    i2 = len;
    toss = true;
end
frame = i1:i2;
% snippet = scg(frame);
nanmask = NaN*ones(size(scg_beat));
scgmask = nanmask;
scgmask(frame) = scg(frame);
snippet = scgmask;

% DEFINE PEAK DETECTION PARAMETERS
mpd = 0;   % min peak distance
mph = 0;   % min peak height
mpp = 0;   % min peak prominence

% DETECT PEAKS
[a_top,i_top,w_top,p_top] = findpeaks(snippet,'minpeakdistance',mpd,'minpeakheight',mph,'minpeakprominence',mpp);
[a_bot,i_bot,w_bot,p_bot] = findpeaks(-snippet,'minpeakdistance',mpd,'minpeakheight',mph,'minpeakprominence',mpp);
n_top = length(a_top);
n_bot = length(a_bot);
t_top = i_top / fs;
t_bot = i_bot / fs;

% ARRAY PEAKS AND VALLEYS
tops = [a_top, i_top, t_top, w_top, p_top, 1*ones(size(a_top))];
bots = [-a_bot, i_bot, t_bot, w_bot, p_bot, -1*ones(size(a_bot))]; 

extremas = [tops; bots];
[~,i_sort] = sort(extremas(:,2));
ext_sort = extremas(i_sort,:);

% IF NO LOCAL EXTREMA ARE DETECTED, RETURN NANS
if n_top + n_bot == 0 
    ext_sort = NaN * ones(1,6);
end

% WHAT TO DO WITH LENGTH-INCOMPATIBLE BEATS (SET TO NAN IF REJECT = 1)
if reject
    if toss
        X = NaN * ones(1,6);
    end
else
    X = ext_sort;
end
   
% RETURN TABLE IF TBLOUT = 1
if tblout
    T = array2table(X);
    T.Properties.VariableNames = {'amp','ind','time','width','prom','sign'};
else
    T = [];
end

% PLOT RESULTS IF PLOTON = 1
if plotOn
    figure, hold on;
    plot(scg_beat);
    plot(snippet);
    plot(X(:,2),X(:,1),'.','markersize',15,'color',[0 0 0]);  
%     legend('full beat','timeframe','extrema');
end
end