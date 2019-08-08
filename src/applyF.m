function ksp = applyF(pcImg, FF, basis, csMap, params)
% Forward Fourier Model for radial acquisition with subspace projection
%
% pcImg = PC subspace coefficient image [imgSize x imgSize x nCoeff]
% FF = NUFFT object
% basis = subspace basis [etl x nCoeff]
% csMap = coil sensitivity [imgSize x imgSize x nCoils]
%
% Mahesh Keerthivasan, 2017
% University of Arizona

% Project from PC subspace to TE image space
pcTemp = reshape(pcImg,[size(pcImg,1) * size(pcImg,2), size(basis,2)]);
tImage = reshape(pcTemp*basis',[size(pcImg,1),size(pcImg,2), size(basis,1)]);

% Apply forward model for radial sampling of the temporal images
ksp = zeros(params.kspDataSize(1),params.kspDataSize(2),params.kspDataSize(3),params.kspDataSize(4));
for tId = 1:size(basis,1)
    % Apply coil sensitivity
    imTemp = csMap.*repmat(tImage(:,:,tId),[1,1,size(csMap,3)]);
    
    % For each coil apply NUFFT operator
    for cid = 1 : size(csMap,3)
        kspTemp = FF{tId} * imTemp(:,:,cid);
        ksp(:,:,cid,tId) = reshape(kspTemp, [params.kspDataSize(1), params.kspDataSize(2)]);
    end
end
end
