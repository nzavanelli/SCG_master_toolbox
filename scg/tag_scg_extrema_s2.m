function [ac,acm,ir,irm,mo,mom] = tag_scg_extrema_s2(E,twin,method,crit)
% *** Identify fiducial markers (extrema) in the SCG waveform S2 complex
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
%         'ir' -> based on IR point (peak)
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
    
    % IF THERE'S AT LEAST ONE EXTREMUM IN THE SEARCH WINDOW
    if sum(inwin) > 0
        
        E_inwin = E(inwin,:);

        % EXTRACT ADJACENT EXTREMA BASED ON PREFERRED METHOD / CRITERIA
        switch method

            % SEARCH FOR PEAKS BASED ON TRUSTWORTHY AO POINT
            case 'ir'
                switch crit
                    % BASED ON PEAK AMPLITUDE
                    case 'amp'
                        [irm,i_ir] = max(E_inwin.amp);
                    % BASED ON PEAK PROMINENCE
                    case 'prom'
                        [irm,i_ir] = max(E_inwin.prom .* E_inwin.sign); 
                        irm = E_inwin.amp(i_ir);
                end
                ir  = E_inwin.time(i_ir);
                J   = find(E.time == ir);

                if J > 2 && J < nexts           % IF THERE ARE ENOUGH EXTREMA TO COUNT FOWARD ONE (MO) AND BACK TWO (AC)
                    i_ac = J - 2;   % count two peaks back for AC
                    i_mo = J + 1;   % count two peaks forward for MO
                    ac = E.time(i_ac);
                    acm = E.amp(i_ac);
                    mo = E.time(i_mo);
                    mom = E.amp(i_mom);

                % TODO -> OTHER STATES

                else
                    ac = NaN;
                    acm = NaN;
                    mo = NaN;
                    mom = NaN;
                end

            % TODO -> ADD OTHER METHODS BESIDES BASING IT ON IR POINT

        end
        
    
    % IF THERE ARE NO EXTREMA IN THE SEARCH WINDOW, RETURN NAN FOR ALL
    else
        ir = NaN;
        irm = NaN;
        ac = NaN;
        acm = NaN;
        mo = NaN;
        mom = NaN;  
    end
    
% %     E_inwin = E(inwin,:);
% % 
% %     % EXTRACT ADJACENT EXTREMA BASED ON PREFERRED METHOD / CRITERIA
% %     switch method
% % 
% %         % SEARCH FOR PEAKS BASED ON TRUSTWORTHY AO POINT
% %         case 'ir'
% %             switch crit
% %                 % BASED ON PEAK AMPLITUDE
% %                 case 'amp'
% %                     [irm,i_ir] = max(E_inwin.amp);
% %                 % BASED ON PEAK PROMINENCE
% %                 case 'prom'
% %                     [irm,i_ir] = max(E_inwin.prom);        
% %             end
% %             ir  = E_inwin.time(i_ir);
% %             J   = find(E.time == ir);
% %             
% %             if J > 2 && J < nexts           % IF THERE ARE ENOUGH EXTREMA TO COUNT FOWARD ONE (MO) AND BACK TWO (AC)
% %                 i_ac = J - 2;   % count two peaks back for AC
% %                 i_mo = J + 1;   % count two peaks forward for MO
% %                 ac = E.time(i_ac);
% %                 acm = E.amp(i_ac);
% %                 mo = E.time(i_mo);
% %                 mom = E.amp(i_mom);
% %                 
% %             % TODO -> OTHER STATES
% %             
% %             else
% %                 ac = NaN;
% %                 acm = NaN;
% %                 mo = NaN;
% %                 mom = NaN;
% %             end
% %                  
% %         % TODO -> ADD OTHER METHODS BESIDES BASING IT ON IR POINT
% %        
% %     end

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
    
    % IF THERE'S AT LEAST ONE EXTREMUM IN THE SEARCH WINDOW
    if sum(inwin) > 0
        
        E_inwin = E(inwin,:);

        % EXTRACT ADJACENT EXTREMA BASED ON PREFERRED METHOD / CRITERIA
        switch method

            % SEARCH FOR PEAKS BASED ON TRUSTWORTHY AO POINT
            case 'ir'
                switch crit
                    % BASED ON PEAK AMPLITUDE
                    case 'amp'
                        [irm,i_ir] = max(E_inwin(:,acol));
                    % BASED ON PEAK PROMINENCE
                    case 'prom'
                        [irm,i_ir] = max(E_inwin(:,pcol) .* E_inwin(:,scol));   
                        irm = E_inwin(i_ir,acol);
                end
                ir  = E_inwin(i_ir,tcol);
                J   = find(time == ir);

                if J > 2 && J < nexts           % IF THERE ARE ENOUGH EXTREMA TO COUNT FOWARD ONE (MO) AND BACK TWO (AC)
                    i_ac = J - 2;   % count two peaks back for AC
                    i_mo = J + 1;   % count two peaks forward for MO
                    ac = time(i_ac);
                    acm = amp(i_ac);
                    mo = time(i_mo);
                    mom = amp(i_mo);
                % TODO -> OTHER IF STATEMENTS
                else
                    ac = NaN;
                    acm = NaN;
                    mo = NaN;
                    mom = NaN;
                end

            % TODO -> ADD OTHER METHODS THAN BASED ON IR POINT
        end
        
    % IF THERE ARE NO EXTREMA IN THE SEARCH WINDOW, RETURN NAN FOR ALL
    else
        ir = NaN;
        irm = NaN;
        ac = NaN;
        acm = NaN;
        mo = NaN;
        mom = NaN;  
    end
    
    
    
    
    
% %     E_inwin = E(inwin,:);
% % 
% %     % EXTRACT ADJACENT EXTREMA BASED ON PREFERRED METHOD / CRITERIA
% %     switch method
% % 
% %         % SEARCH FOR PEAKS BASED ON TRUSTWORTHY AO POINT
% %         case 'ir'
% %             switch crit
% %                 % BASED ON PEAK AMPLITUDE
% %                 case 'amp'
% %                     [irm,i_ir] = max(E_inwin(:,acol));
% %                 % BASED ON PEAK PROMINENCE
% %                 case 'prom'
% %                     [irm,i_ir] = max(E_inwin(:,pcol));        
% %             end
% %             ir  = E_inwin(i_ir,tcol);
% %             J   = find(time == ir);
% %             
% %             if J > 2 && J < nexts           % IF THERE ARE ENOUGH EXTREMA TO COUNT FOWARD ONE (MO) AND BACK TWO (AC)
% %                 i_ac = J - 2;   % count two peaks back for AC
% %                 i_mo = J + 1;   % count two peaks forward for MO
% %                 ac = time(i_ac);
% %                 acm = amp(i_ac);
% %                 mo = Etime(i_mo);
% %                 mom = amp(i_mom);
% %             % TODO -> OTHER IF STATEMENTS
% %             else
% %                 ac = NaN;
% %                 acm = NaN;
% %                 mo = NaN;
% %                 mom = NaN;
% %             end
% %         
% %         % TODO -> ADD OTHER METHODS THAN BASED ON IR POINT
% %     end
        
end


end