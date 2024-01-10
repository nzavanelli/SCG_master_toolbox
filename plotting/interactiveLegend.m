function interactiveLegend(src,evnt)
% * Callback function to toggle the visibility of a data series in a plot
%   by clicking on its legend entry
% * How to use, e.g.:
%       plot(rand(4));
%       l = legend('Line 1','Line 2','Line 3','Line 4');
%       l.ItemHitFcn = @interactiveLegend;
% * Make sure function is in the active search path!

if strcmp(evnt.Peer.Visible,'on')
    evnt.Peer.Visible = 'off';
else 
    evnt.Peer.Visible = 'on';
end

end