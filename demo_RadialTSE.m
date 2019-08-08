%% Subspace constrained reconstruction of Radial Turbo Spin Echo data
% Demo script
%
% Mahesh Keerthivasan, 2017
% University of Arizona

%% Set path to toolboxes and source 
addpath(genpath('./src/')); 
addpath(genpath('./toolbox/')); 

%% Load k-space data and protocol parameters
load('./data/kspData.mat')
load('./data/protParams.mat');
load('./data/cmap.mat')

%% Setup Reconstruction related parameters
reconParams.reconImgSize = [256,256];
reconParams.numCoeff = 4; % number of PC coefficients to retain

reconParams.lambdaTV = 1e-8;
reconParams.lambdaLLR = 1e-5;
reconParams.blockSizeLLR = 8;

reconParams.rho = 5e-3;
reconParams.max_iter = 3;

reconParams.lsqr_ops.tol = 1e-4;
reconParams.lsqr_ops.max_iter = 10;

%% 
teImage = subspaceReconInterface(kspData, csMap, reconParams, protParams);
figure; imshow3(1e3.*rot90(abs(teImage(:,:,[5,8,11,15,18]))),[10 400]); 
