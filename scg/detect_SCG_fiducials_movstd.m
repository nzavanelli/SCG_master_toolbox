function [AO,AO_magn,IVC,IVC_magn,MC,MC_magn] = detect_SCG_fiducials_movstd(M,fs,timewindow,neighbor,plotOn)
% *** Detect fiducial markers on the SCG waveforms based on moving window
% standard deviation (which should denote conspicuous systolic events)
% IN
%     - M : MxN array of segmented SCG waveforms (M = max signal length, N = # beats)
%     - fs : sampling rate (Hz)
%     - timewindow : [x y] time frame in which to look for the systolic event (s)
%         x -> earliest acceptable AO point
%         y -> latest acceptable AO point
%     - plotOn : plot result (1) or not (0)
% OUT
%     - AO : aortic valve opening timing (ref. to beginning of cycle, likely R peak)
%     - AO_magn : magnitude of AO point
%     - IVC : isovolumetric contraction moment timing (ref. to beginning of cycle, likely R peak)
%     - IVC_magn : magnitude of ICP point    
%     - MC : mitral valve closure timing (ref. to beginning of cycle, likely R peak)
%     - MC_magn : magnitude of MC point

% neighbor    = 'before';
stdwin      = 20;

if nargin < 3
    timewindow  = [0.1 0.2];
    neighbor = 'nearest';
    plotOn      = 0;
elseif nargin == 3
    plotOn      = 0;
end

ix_earliest     = round(timewindow(1) * fs);
ix_latest       = round(timewindow(2) * fs);
ncycs           = size(M,2);

% PREALLOCATE
% AO          = NaN * ones(1,ncycs);
% AO_magn     = NaN * ones(1,ncycs);
% IVC         = NaN * ones(1,ncycs);
% IVC_magn    = NaN * ones(1,ncycs);
% MC          = NaN * ones(1,ncycs);
% MC_magn     = NaN * ones(1,ncycs);

for cyc = 1:ncycs
    
    m   = M(:,cyc);
    ms  = movstd(m,stdwin) ./ std(m,'omitnan');

    [px_m,ix_m,wd_m,pr_m]       = findpeaks(m);   % detect peaks on signal
    [bot_m,ix_bot_m]            = findpeaks(-m);       % detect valleys on signal
    [px_ms,ix_ms,wd_ms,pr_ms]   = findpeaks(ms);  % detect peaks on moving std of signal

    inframe_m       = ix_m > ix_earliest & ix_m < ix_latest;  % define which signal peaks are in frame
    ix_m_inframe    = ix_m(inframe_m);
    
    % If there simply are no peaks in the frame of interest,  return NaN
    if isempty(ix_m_inframe)
        AO(cyc)         = NaN;
        AO_magn(cyc)    = NaN;
        IVC(cyc)        = NaN;
        IVC_magn(cyc)   = NaN;
        MC(cyc)         = NaN;
        MC_magn(cyc)    = NaN;
        continue
    end
    
    % DEFINE VALID PEAKS IN THE MOVSTD WAVEFORM
%     inframe_ms = ix_ms > ix_earliest & ix_ms < ix_latest;   % based on which movstd peaks are in frame
    inframe_ms = ix_ms>min(ix_m_inframe) & ix_ms<max(ix_m_inframe); % based which movstd peaks are within the range of possible AO peaks
    
    % IF THERE ARE NO MOVSTD PEAKS IN THE DEFINED FRAME, SIMPLY PICK THE BIGGEST IN-FRAME SIGNAL PEAK AS AO POINT 
    if ~isempty(inframe_ms) 
        % FIND AO
        AO_magn(cyc)    = max(px_m(inframe_m));
        i_AO            = find(px_m == AO_magn(cyc));
        AO(cyc)         = ix_m(i_AO);
        
        % FIND MC (FIRST PEAK PRECEDING AO)
        if i_AO > 2
            i_MC            = i_AO-1;
            MC(cyc)         = ix_m(i_MC);
            MC_magn(cyc)    = px_m(i_MC);            
        end
        
        % FIND IVC (FIRST TROUGH PRECEDING AO)
        i_IVC           = sum((AO(cyc) - ix_bot_m) > 0);
        IVC(cyc)        = ix_bot_m(i_IVC);
        IVC_magn(cyc)   = -bot_m(i_IVC);
                
        % FAILSAFE -> assign NaN to all
%         AO(cyc)       = NaN;
%         AO_magn(cyc)  = NaN;
%         IVC(cyc)      = NaN;
%         IVC_magn(cyc) = NaN;
%         MC(cyc)       = NaN;
%         MC_magn(cyc)  = NaN;

    % IF THERE ARE MOVSTD PEAKS IN THE DEFINED FRAME, FIND THE MOST PROMINENT ONE AND USE IT TO LOCATE AO BASED ON DESIRED NEIGHBOR METHOD
    else
        acme_ms         = max(pr_ms(inframe_ms));   % pick out most prominent peak from the moving std
        ix_acme         = ix_ms(find(pr_ms == acme_ms));     % get true index of most prominent movstd peak    
        AO_candidates   = ix_acme - ix_m;
        switch neighbor
            case 'before'   % Find SCG peak JUST BEFORE peak movstd           
                AO_candidates(AO_candidates < 0) = [];
                i_AO = length(AO_candidates);
            case 'nearest'  % Find SCG peak NEAREST peak movstd
                [AO_cand_min,i_AO_cand_min] = min(abs(AO_candidates));
                AO_cand_min_sign = sign(AO_candidates);
                i_AO = find(AO_candidates == AO_cand_min .* AO_cand_min_sign(i_AO_cand_min));
        end

        if ~isempty(AO_candidates)

            AO(cyc)         = ix_m(i_AO);
            AO_magn(cyc)    = px_m(i_AO);

            % Find first minimum before AO -> IVC
            IVC_candidates = AO(cyc) - ix_bot_m;
            IVC_candidates(IVC_candidates < 0) = [];
            if ~isempty(IVC_candidates)
                i_IVC           = length(IVC_candidates);
                IVC(cyc)        = ix_bot_m(i_IVC);
                IVC_magn(cyc)   = -bot_m(i_IVC);

                % Find first maximum before IVC -> MC
                MC_candidates = IVC(cyc) - ix_m;
                MC_candidates(MC_candidates < 0) = [];
                if ~isempty(MC_candidates)
                    i_MC            = length(MC_candidates);
                    MC(cyc)         = ix_m(i_MC);
                    MC_magn(cyc)    = px_m(i_MC);
                else
                    MC(cyc)         = NaN;
                    MC_magn(cyc)    = NaN;
                end
            else 
                IVC(cyc)        = NaN;
                IVC_magn(cyc)   = NaN;
                MC(cyc)         = NaN;
                MC_magn(cyc)    = NaN;
            end 
        else
            AO(cyc)         = NaN;
            AO_magn(cyc)    = NaN;
            IVC(cyc)        = NaN;
            IVC_magn(cyc)   = NaN;
            MC(cyc)         = NaN;
            MC_magn(cyc)    = NaN;
        end
    end  
end

if plotOn
    ens_avg_mat(M,1);
    co = lines;
    hold on;
    mksize = 20;
    mkalpha = 0.4;
    scatter(AO,AO_magn,mksize,co(1,:),'filled','markerfacealpha',mkalpha);
    scatter(MC,MC_magn,mksize,co(2,:),'filled','markerfacealpha',mkalpha);
    scatter(IVC,IVC_magn,mksize,co(3,:),'filled','markerfacealpha',mkalpha);
    legend('SCG avg','SCG std','AO','MC','IVC');
    legend('boxoff');
    sdf('clean');
end
end