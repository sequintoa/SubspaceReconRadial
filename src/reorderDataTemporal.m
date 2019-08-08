function kspDataTemporal = reorderDataTemporal(kspData, protParams)
% Reorder acquired data into temporal under-sampled sets
%
% Mahesh Keerthivasan, 2017
% University of Arizona

%% Get the acquisition view ordering
[viewVec, viewTable, angles, angleTable] = getFSEViewOrder(protParams.etl,protParams.radialViews,protParams.radialViewOrderType);

%% Separate kspace lines for each TE. Each time point has nSpokes / ETL spokes
[nReadouts,nViews,nCoils] = size(kspData);

kspScaleFac = 300;
kspDataTemporal = zeros(protParams.readoutPoints,protParams.radialViews/protParams.etl, nCoils, protParams.etl);
for echoIdx = 1 : protParams.etl
    kspDataTemporal(:,:,:,echoIdx) = kspScaleFac * kspData(:,viewTable(:,echoIdx)'+1,:);
end


end