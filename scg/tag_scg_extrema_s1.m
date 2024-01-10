function [ao,aom,mc,mcm,ic,icm] = tag_scg_extrema_s1(E,twin,method,crit)
% *** Identify fiducial markers (extrema) in the SCG waveform S1 complex
% IN
%     - E : table of SCG beat extrema, containing at least the following:
%         T.time -> time of each extremum from start of beat (s)
%         T.amp -> amplitude of each extremum
%         T.prom -> prominence of each extremum
%         T.sign -> sign of extremum (1 = peak, -1 = valley)
%     OR
%     - E : PxQ array of SCG beat extrema (P = # extrema, Q = # descriptors), where
%         M(:,1) -> amplitude
%         M(:,3) -> time
%         M(:,5) -> prominence
%         M(:,6) -> sign
%     - twin : search window in which to look for marker [t1 t2] (s)
%     - method : which fiducial marker to reference off of
%         'ao' -> based on AO point
%         'ic' -> based on IVC point
%     - crit : criterion for which to look for marker of interest
%         'amp' -> max amplitude
%         'prom' -> max prominence
        

nexts = size(E,1);  % number of peaks / valleys

% ---------------------------------- %
% IF THE INPUT IS A TABLE
% ---------------------------------- %
if istable(E)
    
    % ONLY INCLUDE EXTREMA IN SEARCH WINDOW
    inwin = E.time > twin(1) & E.time < twin(2);
    T_inwin = E(inwin,:);

    % EXTRACT ADJACENT EXTREMA BASED ON PREFERRED METHOD / CRITERIA
    switch method

        % SEARCH FOR PEAKS BASED ON TRUSTWORTHY AO POINT
        case 'ao'
            switch crit
                % BASED ON PEAK AMPLITUDE
                case 'amp'
                    [aom,i_ao] = max(T_inwin.amp);
                % BASED ON PEAK PROMINENCE
                case 'prom'
                    [aom,i_ao] = max(T_inwin.prom .* T_inwin.sign);
                    aom = T_inwin.amp(i_ao);
            end
            ao  = T_inwin.time(i_ao);
            J   = find(E.time == ao);
            if J > 2                        % IF THERE ARE ENOUGH EXTREMA TO COUNT BACK TO MC
                i_ic    = J-1;
                i_mc    = J-2;
                ic      = E.time(i_ic);
                icm     = E.amp(i_ic);
                mc      = E.time(i_mc);
                mcm     = E.amp(i_mc);
            elseif J == 2                   % IF YOU CAN ONLY COUNT BACK TO IC
                i_ic    = J-1;
                ic      = E.time(i_ic);
                icm     = E.amp(i_ic);
                mc      = NaN;
                mcm     = NaN;
            else                            % IF YOU CAN'T COUNT BACK AT ALL
                ic      = NaN;
                icm     = NaN;
                mc      = NaN;
                mcm     = NaN;
            end      

        % SEARCH FOR PEAKS BASED ON TRUSTWORTHY IC (IVC) POINT    
        case 'ic'
            switch crit
                % BASED ON PEAK AMPLITUDE
                case 'amp'
                    [icm,i_ic] = min(T_inwin.amp);
                % BASED ON PEAK PROMINENCE
                case 'prom'
                    [icm,i_ic] = min(T_inwin.prom .* T_inwin.sign);
                    icm = T_inwin.amp(i_ic);
            end
            ic = T_inwin.time(i_ic);
            J = find(E.time == ic);
            if J > 1 && J < nexts           % IF THERE ARE ENOUGH TO COUNT 1 EITHER SIDE
                i_ao    = J+1;
                i_mc    = J-1;
                ao      = E.time(i_ao);
                aom     = E.amp(i_ao);
                mc      = E.time(i_mc);
                mcm     = E.amp(i_mc);
            elseif J == 1 && J < nexts      % IF YOU CAN ONLY COUNT TO THE RIGHT
                i_ao    = J+1;
                ao      = E.time(i_ao);
                aom     = E.amp(i_ao);
                mc      = NaN;
                mcm     = NaN;
            else                            % IF YOU CAN'T COUNT EITHER DIRECTION
                ao      = NaN;
                aom     = NaN;
                mc      = NaN;
                mcm     = NaN;
            end
    end

% ---------------------------------- %
% IF THE INPUT IS AN ARRAY  
% ---------------------------------- %
else
    
    acol = 1;
    tcol = 3;
    pcol = 5;
    scol = 6;
    
    time = E(:,tcol);
    amp = E(:,acol);
    prom = E(:,pcol);
    sgn = E(:,scol);
    
    % ONLY INCLUDE EXTREMA IN SEARCH WINDOW
    inwin = time > twin(1) & time < twin(2);
    E_inwin = E(inwin,:);

    % EXTRACT ADJACENT EXTREMA BASED ON PREFERRED METHOD / CRITERIA
    switch method

        % SEARCH FOR PEAKS BASED ON TRUSTWORTHY AO POINT
        case 'ao'
            switch crit
                % BASED ON PEAK AMPLITUDE
                case 'amp'
                    [aom,i_ao] = max(E_inwin(:,acol));
                % BASED ON PEAK PROMINENCE
                case 'prom'
                    [aom,i_ao] = max(E_inwin(:,pcol) .* E_inwin(:,scol));
                    aom = E_inwin(i_ao,acol);
            end
            
            if ~isempty(i_ao)                   % IF THERE'S AT LEAST ONE MAXIMUM IN THE WINDOW
                ao  = E_inwin(i_ao,tcol);
                J   = find(time == ao);
                if J > 2                        % IF THERE ARE ENOUGH EXTREMA TO COUNT BACK TO MC
                    i_ic    = J-1;
                    i_mc    = J-2;
                    ic      = time(i_ic);
                    icm     = amp(i_ic);
                    mc      = time(i_mc);
                    mcm     = amp(i_mc);
                elseif J == 2                   % IF YOU CAN ONLY COUNT BACK TO IC
                    i_ic    = J-1;
                    ic      = time(i_ic);
                    icm     = amp(i_ic);
                    mc      = NaN;
                    mcm     = NaN;
                else                            % IF YOU CAN'T COUNT BACK AT ALL
                    ic      = NaN;
                    icm     = NaN;
                    mc      = NaN;
                    mcm     = NaN;
                end   
            else
                ao      = NaN;
                aom     = NaN;
                ic      = NaN;
                icm     = NaN;
                mc      = NaN;
                mcm     = NaN;
            end
        
        % SEARCH FOR PEAKS BASED ON TRUSTWORTHY IC (IVC) POINT    
        case 'ic'
            switch crit
                % BASED ON PEAK AMPLITUDE
                case 'amp'
                    [icm,i_ic] = min(E_inwin(:,acol));
                % BASED ON PEAK PROMINENCE
                case 'prom'
                    [icm,i_ic] = min(E_inwin(:,pcol) .* E_inwin(:,scol));
                    icm = E_inwin(i_ic,acol);
            end
            ic = E_inwin(i_ic,tcol);
            J = find(time == ic);
            if J > 1 && J < nexts           % IF THERE ARE ENOUGH TO COUNT 1 EITHER SIDE
                i_ao    = J+1;
                i_mc    = J-1;
                ao      = time(i_ao);
                aom     = amp(i_ao);
                mc      = time(i_mc);
                mcm     = amp(i_mc);
            elseif J == 1 && J < nexts      % IF YOU CAN ONLY COUNT TO THE RIGHT
                i_ao    = J+1;
                ao      = time(i_ao);
                aom     = amp(i_ao);
                mc      = NaN;
                mcm     = NaN;
            else                            % IF YOU CAN'T COUNT EITHER DIRECTION
                ao      = NaN;
                aom     = NaN;
                mc      = NaN;
                mcm     = NaN;
            end
    end
    
end


end