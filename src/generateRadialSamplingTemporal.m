function FF = generateRadialSamplingTemporal(protParams, reconParams) 
%% Generate Non-Uniform FFT Sampling operator for the temporal data:
% Makes use of IRT toolbox along with NUFFT class from SparseMRI
% 
% Mahesh Keerthivasan, 2017
% University of Arizona

%% Get the acquisition angular ordering
[~, ~, ~, angleTable] = getFSEViewOrder(protParams.etl,protParams.radialViews,protParams.radialViewOrderType);

%% Generate NUFFT operator
FF = cell(protParams.etl,1);
for echoIdx = 1 : protParams.etl
    theta = angleTable(:,echoIdx)';
    kspaceVec = generateRadialTraj(theta, protParams.readoutPoints);
    FF{echoIdx} =  NUFFT(kspaceVec,1, 1, 0,reconParams.reconImgSize, 2);
end
end