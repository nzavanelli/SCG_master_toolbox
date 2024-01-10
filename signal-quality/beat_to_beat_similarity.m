function [sm] = beat_to_beat_similarity(beat1,beat2,fs,metric)
% *** Quantify similarity of cardiac waveforms from beat to beat
% IN
%     - beat1,beat2 : 1xN vectors (! SHOULD BE THE SAME LENGTH AND FS !)
%     - fs : sampling rate (Hz)
%     - metric : method of comparison between waveforms
%     	- 'xc' : cross-correlation (returns max and lag)
%     	- 'xcn' : normalized cross-correlation (returns max and lag)
%     	- 'cs' : cosine similarity
%     	- 'pd' : pairwise distance
%     	- 'sc' : spectral coherence
% OUT
%     - sm : similarity metric of interest

% IN CASE SIGNALS ARE SIZED DIFFERENTLY
len1 = length(beat1);
len2 = length(beat2);
if len1 ~= len2
%     warning('Signals are of different length. Padding shorter signal.');
    maxlen = max([len1 len2]);
    vessel = NaN * ones(maxlen,1);
    if len1 > len2
        vessel(1:len2) = beat2;
        beat2 = vessel;
    end
    if len2 > len1
        vessel(1:len1) = beat1;
        beat1 = vessel;
    end 
    len = maxlen;
else
    len = length(beat1);
end

% REPLACE NAN WITH ZEROS (or whatever)
nanreplace = 0;
beat1(isnan(beat1)) = nanreplace;
beat2(isnan(beat2)) = nanreplace;

%% COMPUTE CROSS CORRELATION TO GET LAGS AND SHIFT
maxlag = 50;
% [cc,lags] = xcorr(beat1,beat2,maxlag);
[cc,lags] = xcorr(beat1,beat2,maxlag,'normalized');
[xc,ix_xc] = max(abs(cc));
lag = lags(ix_xc);

%%
switch metric 
    case 'xc'
        % CROSS-CORRELATION (XC)
%         maxlag = 50;
% %         [cc,lags] = xcorr(beat1,beat2,maxlag);
%         [cc,lags] = xcorr(beat1,beat2,maxlag,'normalized');
%         [xc,ix_xc] = max(abs(cc));
%         lag = lags(ix_xc);
        sm = [xc,lag];
    case 'xcn'
        % CROSS-CORRELATION NORMALIZED (XCN)
        ccn = normxcorr2(beat1,beat2);
        [xc_n,ix_xc_n] = max(abs(ccn));
        lag_n = len - ix_xc_n;
        sm = [xc_n,lag_n];
    case 'cs'
        % COSINE SIMILARITY (CS)
        cs = getCosineSimilarity(beat1,beat2);
        sm = cs;
    case 'pd'
        % PAIRWISE DISTANCE (PD)
        distance_metric = 'mahalanobis';
        PD = pdist2(beat1,beat2,distance_metric);
        pd = rms(diag(PD));
        sm = pd;
    case 'sc'
        % SPECTRAL COHERENCE (SC)
        [sc,freq] = mscohere(beat1,beat2,[],[],[],fs);
        sm = [sc,freq];
end

end