function [C,tref] = get_moving_cardiodicity(x,fs,twin,ovlp)
%Nathan Zavanelli

%x = input vector
%fs - sampling rate
%twin - time window (seconds)
%ovlp - overlap (range 0-1)

%C - repeatability
%tref - time stamps for C

% DIVIDE SIGNALS INTO INTERVAL FRAMES
len             = length(x);
framesize       = round(twin * fs);
shift           = round(framesize * (1-ovlp));

i1      = 1;
incr    = 1;
while i1 < len
    if i1 <= (len - framesize)
        i2  = i1 + framesize;
    elseif i1 > (len - framesize) && i1 < len
        i2	= len;
    end
    frame   = i1:i2;
    snippet = x(frame);
    
     ans =  get_cardiodicity(snippet,fs);
     if ~isempty(ans)
       C(incr) = ans;
     else
         C(incr) = 0;
     end
    iref(incr,1)    = i1;
    tref(incr,1)    = i1 / fs;
    i1              = i1 + shift;
    incr            = incr + 1;
end

end