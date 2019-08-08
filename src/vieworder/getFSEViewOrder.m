function [viewVec,viewtable, angleVec, angleTable] = getFSEViewOrder(etl,nSpokes,orderType)
% Calculates the view order for Radial Turbo Spin Echo pulse sequence
% Supports different view orderings specified by orderType
% FSE Acquisition can be described as following
% for ETL = 4 and nSpokes = 12
%
% ----- Shot1_Eco1 Shot1_Eco2 Shot1_Eco3 Shot1_Eco4 ----
% ----- Shot2_Eco1 Shot2_Eco2 Shot2_Eco3 Shot2_Eco4 ----
% ----- Shot3_Eco1 Shot3_Eco2 Shot3_Eco3 Shot3_Eco4 ----
%
% In above illustration, shot dimension is along the y-axis (length == 3) while echo
% dimension is along the x-axis (length == 4).
% Inputs:
% etl: echo train length
% nSpokes: total number of radial spokes prescribed
% orderType :   0 - Sequential from 0 - pi
%               1 - Bit reversed : as outlined in Theilmann et al 2004 MRM
%               2 - Bit reversed modified : modification of Theilmann's
%               algorithm to avoid failure use cases
%               3 - GA TE : Golden angle sampling along the shot dimension
%               8 - GA TR : Golden angle sampling along the echo dimension
%
% Outputs: Returns the view table used in acquisition along with azimuthal
% angles
%
% Mahesh Keerthivasan, 2014
% University of Arizona

numShots = nSpokes / etl;

viewtable = zeros(numShots, etl);
viewVec = zeros(nSpokes,1);

if orderType == 0 % sequential
    idx1 = 1;
    view = 0;
    for shotIdx = 0 :numShots-1
        for ecoIdx = 0 : etl-1
            viewtable(shotIdx+1, ecoIdx+1) = view;
            viewVec(idx1) = view;
            idx1 = idx1 + 1;
            view = view + 1;
        end
    end
    deltaAngle = pi / nSpokes;
    angleVec = viewVec .* deltaAngle;
    angleTable = viewtable .* deltaAngle;
    
elseif orderType == 1 % Bit Reversed
    [viewVec,viewtable] = getBitRevViewOrder(etl,nSpokes);
    deltaAngle = pi / nSpokes;
    angleVec = viewVec .* deltaAngle;
    angleTable = viewtable .* deltaAngle;
    
elseif orderType == 2 % Modified Bit Reversed order
    [viewVec,viewtable] = getBitRevViewOrderModified(etl,nSpokes);
    deltaAngle = pi / nSpokes;
    angleVec = viewVec .* deltaAngle;
    angleTable = viewtable .* deltaAngle;
    
elseif orderType == 3
    % golden angle - lines acquired sequentially across echoes and
    % continues across TRs i. all lines in TE1 is GA separated and line at TE2-TR1 is num_et*GA+GA
    idx1 = 1;
    for shotIdx = 0 :numShots-1
        for ecoIdx = 0 : etl-1
            view = shotIdx + (numShots * ecoIdx);
            viewtable(shotIdx+1, ecoIdx+1) = view;
            viewVec(idx1) = view;
            idx1 = idx1 + 1;
        end
    end
    deltaAngle = pi/180. * 111.246117975;
    angleVec = viewVec .* deltaAngle;
    angleTable = viewtable .* deltaAngle;
    
elseif orderType == 8 % GA continuous in TR i.e. all spokes within a shot (TR)
    % are GA apart and this continues to next shot
    idx1 = 1;
    view = 0;
    for shotIdx = 0 :numShots-1
        for ecoIdx = 0 : etl-1
            viewtable(shotIdx+1, ecoIdx+1) = view;
            viewVec(idx1) = view;
            idx1 = idx1 + 1;
            view = view + 1;
        end
    end
    deltaAngle = pi/180. * 111.246117975;
    angleVec = viewVec .* deltaAngle;
    angleTable = viewtable .* deltaAngle;
    
else
    error('Specified ViewOrder not defined in getFSEViewOrder() !!') ;
end


end
