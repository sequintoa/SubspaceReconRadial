% Simulate radial view ordering for fast spin echo acquisition
% Mahesh Keerthivasan,
% March 2015

%% Setup parameters
etl = 32;
nSpokes = 160;

%% Simulate view ordering

% Bit Reversed ordering
viewOrder = 2;
[viewVec_br, viewTable_br, angles_br, angleTable_br] = getFSEViewOrder(etl,nSpokes,viewOrder);

% Golden Angle ordering
viewOrder = 3;
[viewVec_ga, viewTable_ga, angles_ga, angleTable_ga] = getFSEViewOrder(etl,nSpokes,viewOrder);

%% Display radial coverage
ecoId = 2;
plotRadialAngles(angleTable_br(:,id));
title(['Radial coverage for Echo ', num2str(ecoId),' : Bit Reversed Order']);
plotRadialAngles(angleTable_ga(:,id));
title(['Radial coverage for Echo ', num2str(ecoId),' : Golden Angle Order']);


