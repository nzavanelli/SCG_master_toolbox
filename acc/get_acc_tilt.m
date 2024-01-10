function [theta,chi,phi] = get_acc_tilt(x,y,z,win,fs,plotOn)
% *** Extract tilt angle (rel. to gravity) to determine sleep position
% *** From angle of inclination method described at https://www.digikey.com/en/articles/using-an-accelerometer-for-inclination-sensing 
% *** "Global" coordinate frame : gravity down ([0 0 -9.8])
% IN
%     - x,y,z : 1xN vectors of accelerometer data
%     - fs : sample rate (Hz)
%     - win : time window in which to compute DC component (s)
%     - plotOn : plot result (1) or not (0)
% OUT
%     - theta : angle b/t accelerometer x and "global" x
%     - chi : angle b/t accelerometer y and "global" y
%     - phi : angle b/t accelerometer z and "global" z

% win = fs*15;
acc = [x y z];
acc_m = movmean(acc,win*fs);

X = acc_m(:,1);
Y = acc_m(:,2);
Z = acc_m(:,3);
XY = sqrt(X.^2+Y.^2);
YZ = sqrt(Y.^2+Z.^2);
XZ = sqrt(X.^2+Z.^2);

theta = atan2d(X,YZ);
chi = atan2d(Y,XZ);
phi = atan2d(XY,Z);

if plotOn
    figure;
    hold on;
    t = (1:length(x)) / fs;
    plot(t,theta);
    plot(t,chi);
    plot(t,phi);
    xlabel('Time (s)');
    ylabel('Angle (deg)');
    title('Orientation wrt. Gravity');
    legend('theta','chi','phi');
    legend('boxoff');
end

end