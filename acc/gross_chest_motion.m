% EXTRACT CHEST WALL MOTION AND SLEEP ORIENTATION FROM ACCELEROMETER
%% DEFINE INPUTS
ix = 1:height(hux);
% ix = istart_hux:height(hux);
fs = 500;

accx = hux.x1(ix);
accy = hux.y1(ix);
accz = hux.z1(ix);

%% GET TILT ANGLE OF ACCELEROMETER REL. TO GRAVITY FRAME
plotOn_tilt = 1;
[theta,chi,phi] = get_acc_tilt(accx,accy,accz,15,fs,plotOn_tilt);
tilt = phi;

%% SUBTRACT DC COMPONENT OF ACCELERATION
dc_win = 15;    % sec
accx_ac = remove_acc_dc(accx,dc_win,fs);
accy_ac = remove_acc_dc(accy,dc_win,fs);
accz_ac = remove_acc_dc(accz,dc_win,fs);

%% FILTER FOR RESPIRATION SIGNAL (ULTRA LOW FREQ)
resp_cutoff = 1;
respx = filter_acc_resp(accx_ac,fs,resp_cutoff,0);
respy = filter_acc_resp(accy_ac,fs,resp_cutoff,0);
respz = filter_acc_resp(accz_ac,fs,resp_cutoff,0);

%% DEFINE RESPIRATION SIGNAL TO USE FOR TIDAL MOVEMENT ANALYSIS
resp_method = '1chan';
switch resp_method
    case '1chan' % Use single channel of accel to respresent chest motion
        resp = respx;
    case 'pca' % Use PCA to determine axis of highest variance in resp. band
        npcs = 1;
        [resp,varex] = get_acc_pca(respx,respy,respz,npcs,1);
end

%% ANALYZE CHEST WALL MOVEMENT PATTERNS
[tide,rphase,effort,insp,expr] = get_tidal_movements(resp,fs,1);
