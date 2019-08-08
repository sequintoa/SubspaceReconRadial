function tImage = applyFT(ksp, FF, basis, csMap, csMapScale, params)
% Adjoint Fourier Model for radial acquisition with subspace projection
%
% ksp = temporal kspace [readOuts x viewPerTime x nCoils x nTime]
% FF = NUFFT object
% basis = subspace basis [etl x nCoeff]
% csMap = coil sensitivity [imgSize x imgSize x nCoils]
%
% Mahesh Keerthivasan, 2017
% University of Arizona

% Apply adjoint of forward model to reconstruct temporal images
tImage = zeros(params.reconImgSize(1),params.reconImgSize(2),size(basis,1));
for tid = 1:size(basis,1)
    % For each coil apply adjoint NUFFT
    imTemp = zeros(params.reconImgSize(1),params.reconImgSize(2), size(csMap,3));
    for cId = 1 : size(csMap,3)
        kspTemp = reshape(ksp(:,:,cId,tid), [params.kspDataSize(1)*params.kspDataSize(2),1]);
        imTemp(:,:,cId) = FF{tid}' * kspTemp;
    end
    
    % Modulate by coil sensitivities
    imTemp = repmat(csMapScale,[1,1,size(csMap,3)]) .* conj(csMap) .* imTemp;
    tImage(:,:,tid) = sum(imTemp,3);
end

% Use subspace basis to project TE images to PC subspace
tTemp = reshape(tImage,[params.reconImgSize(1)*params.reconImgSize(2),size(basis,1)]);
tImage = (reshape(tTemp * basis,[params.reconImgSize(1),params.reconImgSize(2),size(basis,2)]));
return
