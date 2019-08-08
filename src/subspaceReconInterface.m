function teImage = subspaceReconInterface(kspData, csMap, reconParams, protParams)
% Interface script for subspace constrained reconstruction of radial temporal
% k-space data from Turbo Spin Echo acquisition 
% Makes use of subspace basis computed from the signal model along with 
% TV and Locally Low rank regularization 
% 
% Inputs: 
% kspData: [nReadout x nRadialSpokes x nCoils] contains radial spokes from the
% different echo times mixed together
% csMap: [imgSize x imgSize x nCoils] coil sensitivity maps
% reconParams: structure with reconstruction related parameters 
% protParams: structure with acquisition protocol related parameters 
% 
% Mahesh Keerthivasan, 2017
% University of Arizona 

%% Get sensitivity map scaling factor 
reconParams.csMapScale = ones(reconParams.reconImgSize(1));%1./(sum(abs(csMap).^2,3)+1e-15);

%% Compute the subspace basis using the forward signal model 
basis = generateBasis(protParams, reconParams.numCoeff);

%% Reorder acquired data into temporal under-sampled sets
data = reorderDataTemporal(kspData, protParams);
reconParams.kspDataSize = size(data);

%% Generate Non-Uniform FFT Sampling operator for the temporal data:
% Makes use of IRT toolbox along with NUFFT class from SparseMRI
FF = generateRadialSamplingTemporal(protParams, reconParams);

%% Call the ADMM solver to reconstruct the subspace coefficient images
pc_init = zeros(reconParams.reconImgSize(1),reconParams.reconImgSize(2), size(basis,2));
pc_est = subspaceLLR_admm(data, pc_init, FF, basis, csMap, reconParams);

%% Project the subspace coefficient images back to TE image space
pcTemp = reshape(pc_est,[size(pc_est,1) * size(pc_est,2), size(basis,2)]);
teImage = reshape(pcTemp*basis',[size(pc_est,1),size(pc_est,2), size(basis,1)]);

%% Display reconstructed images
figure; imshow3(abs(pc_est));
figure; imshow3(abs(teImage));

end 
