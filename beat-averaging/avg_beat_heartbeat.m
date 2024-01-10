function [M_avg,tref_avg] = avg_beat_heartbeat(M,tref,nbeats,step)
% *** Compute heartbeat-based moving ensemble average of cardiac signal
% IN
%     - M : PxN array of beats 
%         P = max beat length (samples) (columns padded with NaNs)
%         N = # beats (i.e., beats are columns)
%     - tref : Nx1 vector of timing references used to segmenting beats of M (s) 
%         (likely based on R peak)
%     - nbeats : # beats over which to average
%     - step : # beats to shift over from frame to frame
% OUT
%     - M_avg : QxN array of beats
%         Q = ceil((N-1)/step)
%     - tref_avg : Qx1 array of timing references for the beginning of each ensemble average

ncycs = size(M,2);
cyc1 = 1;
incr = 1;

% IF THE FULL FRAME IS AVAILABLE
while cyc1 < ncycs - nbeats 
    cyc2 = cyc1 + nbeats;
    frame = cyc1:cyc2;
    snippet = M(:,frame);
    avg = mean(snippet,2,'omitnan');
    M_avg(:,incr) = avg;
    tref_avg(incr) = tref(cyc1);
    incr = incr + 1;
    cyc1 = cyc1 + step;
end

% IF ONLY PART OF THE FRAME IS AVAILABLE (I.E. AT THE END)
while (cyc1 >= ncycs - nbeats) && (cyc1 < ncycs)
    frame = cyc1:ncycs;
    snippet = M(:,frame);
    avg = mean(snippet,2,'omitnan');
    M_avg(:,incr) = avg;
    tref_avg(incr) = tref(cyc1);
    incr = incr + 1;
    cyc1 = cyc1 + step;
end

end