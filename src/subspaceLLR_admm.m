function [x] = subspaceLLR_admm(data, x_init, FF, basis, csMap, reconParams)
% ADMM solver for reconstruction of temporal radial data with subspace constraints
% Uses L1-TV and Locally Low Rank regularization
%
% Solver based on implementation by Jon Tamir
% "T2 Shuffling: Sharp, Multi-Contrast, Volumetric Fast Spin-Echo Imaging"
% https://github.com/jtamir/t2shuffling-support/
%
% University of California Educational/Research License:
% Copyright (c) 2015-2016. The Regents of the University of California (Regents).
% All Rights Reserved. Permission to use, copy, modify, and distribute this
% software and its documentation for educational, research, and not-for-profit
% purposes, without fee and without a signed licensing agreement, is hereby
% granted, provided that the above copyright notice, this paragraph and the
% following two paragraphs appear in all copies, modifications, and distributions.
% Contact The Office of Technology Licensing, UC Berkeley, 2150 Shattuck Avenue,
% Suite 510, Berkeley, CA 94720-1620, (510) 643-7201, for commercial licensing
% opportunities.
% Created by Jonathan Tamir <jtamir@eecs.berkeley.edu>.
% Department of Electrical Engineering and Computer Sciences,
% University of California, Berkeley.
% IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
% INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF
% THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF REGENTS HAS BEEN
% ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
% Inputs: 
% data: kspace data temporal: [nReadout x nRadialSpokes x nCoils x nTime]
%
% Adapted by: Mahesh Keerthivasan, 2017
% University of Arizona

% create sensitivity encoded Fourier transforms
F = @(im) applyF(im, FF, basis, csMap, reconParams);
FT = @(ksp) applyFT(ksp, FF, basis, csMap, reconParams.csMapScale, reconParams);

% create TV operators
TV2D = @(u) applyTV2D(u);
TVT2D = @(w) applyTVT2D(w);

x = x_init; % initial image
z1 = (TV2D(zeros(size(x))));
u1 = zeros(size(z1));

% Get initial estimate of temporal image
b = FT(data);
z2 = zeros(size(b));
u2 = zeros(size(b));

rho = reconParams.rho;
max_iter = reconParams.max_iter;

lambdaTV = reconParams.lambdaTV;
lambdaLLR = reconParams.lambdaLLR;
block_dim =  [reconParams.blockSizeLLR reconParams.blockSizeLLR];


% Set up operators for least squares
Aop = @(a) FT(F(a));
AHA_lsqr = @(a) vec(rho * TVT2D(TV2D(reshape(a, size(b)))) + ...
    rho * reshape(a, size(b)) + Aop(reshape(a, size(b))));

for ii=1:max_iter
    % update x using LSQR.
    y = b + rho * (TVT2D(z1 - u1) + (z2 - u2));
    a = pcg(AHA_lsqr, y(:), reconParams.lsqr_ops.tol, reconParams.lsqr_ops.max_iter, [], [], x(:));
    x = reshape(a, size(b));
    
    % update z1 using shrinkage
    xpu1 = TV2D(x) + u1;
    z1 = shrinkage(xpu1, lambdaTV / rho);
    
    % update u1
    u1 = xpu1 - z1;
    
    % update z2 using LLR singular value thresholding
    xpu2 = x + u2;
    [z2, s_vals] = llr_thresh(xpu2, lambdaLLR / rho, block_dim);
    
    % update u2
    u2 = xpu2 - z2;
end

end