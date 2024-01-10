function [tide,rphase,effort,insp,expr] = get_tidal_movements(acc,fs,plotOn)
% *** Extract tidal movement data from accelerometer on the chest
% IN
%     - acc : 1xN vector of raw accelerometer data
%     - fs : sample rate (Hz)
%     - plotOn : plot result (1) or not (0)
% OUT
%     - tide : 1xN vector of filtered acc data (tidal movements)
%     - rphase : 1xN vector of respiratory phase
%         0 -> expiration
%         1 -> inspiration
%     - effort : 1xN vector describing amplitude of chest wall movement
%     - insp : 1xN vector tracking peak inspiration
%     - expr : 1xN vector tracking peak expiration
    
resp_cutoff = 1;        % hz
minpeakdist = 1*fs;     % min distance between successive resp. peaks
minpeakprom = 600;      % min prominence (amplitude) of resp. peaks

% FILTER ACC
tide = filter_acc_resp(acc,fs,resp_cutoff,0);

% PEAK DETECTION
[top,ix_top] = findpeaks(tide,'minpeakdistance',minpeakdist,'minpeakprominence',minpeakprom);
[bot,ix_bot] = findpeaks(-tide,'minpeakdistance',minpeakdist,'minpeakprominence',minpeakprom);
bot = -bot;

% GATHER ALL LOCAL OPTIMA AND SORT IN TIME
ix_cod = [ix_top; ix_bot];
cod = [top; bot];
[ix_cod_sort,i_ix_cod_sort] = sort(ix_cod);
cod_sort = cod(i_ix_cod_sort);

% EXTRACT RESPIRATORY PHASE AND STROKE BREATH-TO-BREATH
rphase = ones(size(acc));
stroke = zeros(size(ix_cod_sort));
stroke_abs = zeros(size(ix_cod_sort));

for i = 1:length(ix_cod_sort)-1
    t1 = ix_cod_sort(i);
    t2 = ix_cod_sort(i+1);
    p1 = cod_sort(i);
    p2 = cod_sort(i+1);
    
    % INSPIRATION
    if p2 > p1
        rphase(t1:t2) = 1;  
    end
    % EXPIRATION
    if p1 > p2
        rphase(t1:t2) = 0;
    end
    
    stroke(i) = p2-p1;
    stroke_abs(i) = abs(stroke(i));
end

% INTERPOLATE / SMOOTH VARIABLES TO MATCH INPUT SIGNAL SIZE
interp_method = 'linear';
stroke_abs_interp = interp1(ix_cod_sort,stroke_abs,1:length(acc),interp_method);
peak_insp_interp = interp1(ix_top,top,1:length(acc),interp_method);
peak_expr_interp = interp1(ix_bot,bot,1:length(acc),interp_method);

t_breath_avg = mean(diff(ix_cod_sort));
win = 2 * t_breath_avg;
effort = movmean(stroke_abs_interp,win);
insp = movmean(peak_insp_interp,win/2);
expr = movmean(peak_expr_interp,win/2);

if plotOn
    time = (1:length(acc))/fs;
    co = lines;
    figure;
    sp(1) = subplot(311);
    hold on;
    plot(time,tide,'linewidth',2);
    plot(time,insp,'color',co(2,:));
    plot(time,expr,'color',co(3,:));
%     plot(ix_top,top,'.','markersize',20,'color',co(2,:));
%     plot(ix_bot,bot,'.','markersize',20,'color',co(3,:));
    ylim(5*minpeakprom*[-1 1]);
    title('Tidal Movements');
    legend('acc','pk insp','pk expr');
    legend('boxoff');
    sp(2) = subplot(312);
    plot(time,rphase);
    ylim([-1 2]);
    title({'Respiration Phase','0 = expiration / 1 = inspiration'});
    sp(3) = subplot(313);
    hold on;
    plot(ix_cod_sort/fs,stroke_abs);
    plot(time,effort,'linewidth',2);
    ylim(10*minpeakprom*[0 1]);
    title('Respiratory Effort');
    linkaxes(sp,'x');
end
end