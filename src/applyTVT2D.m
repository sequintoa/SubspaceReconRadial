function u = applyTVT2D(w)
% Adjoint Operator for 2D Spatial Total Variation 
% Implementation based on Sparse MRI Toolbox. 
%
% w = [imgSize x imgSize x nCoeff x 2]
% u = [imgSize x imgSize x nCoeff]

adjDx = w([1,1:end-1],:,:,1) - w(:,:,:,1);
adjDx(1,:,:) = -w(1,:,:,1);
adjDx(end,:,:) = w(end-1,:,:,1);

adjDy = w(:,[1,1:end-1],:,2) - w(:,:,:,2);
adjDy(:,1,:) = -w(:,1,:,2);
adjDy(:,end,:) = w(:,end-1,:,2);

u = (adjDx + adjDy)/2;
end
