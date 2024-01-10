function [x_out] = replace_vals(x_in,method,val)
% *** Replace the interstitial -1 values in the raw PPG signal
% IN
%     - x_in : Nx1 vector
%     - method : method of replacement
%         'NaN' : replace -1 with NaN
%         'zoh' : zero-order hold between successive non-(-1) values
%         'interp' : linear interpolation between successive non-(-1) values
% OUT
%     - x_out : Nx1 corrected vector
    
if nargin < 3
    val = 0;
end

len = length(x_in);
ix = 1:len;
vals = (x_in == val);
keep = ~vals;
ppg_keep = x_in(keep);
ix_keep = ix(keep);

switch method
    case 'NaN'
        x_in(vals) = NaN;
        x_out = x_in;
    case 'zoh'
        x_out = interp1(ix_keep,ppg_keep,ix,'previous');
        x_out = fillmissing(x_out,'nearest');  % if NaNs still exist
    case 'interp'
        x_out = interp1(ix_keep,ppg_keep,ix,'linear');
        x_out = fillmissing(x_out,'nearest');  % if NaNs still exist
end
   
if isrow(x_out)
    x_out = x_out';
end

end