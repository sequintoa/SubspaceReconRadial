function w = applyTV2D(u)
% 2D Spatial Total Variation 
% Implementation based on Sparse MRI Toolbox. 
%
% u = [imgSize x imgSize x nCoeff]
% w = [imgSize x imgSize x nCoeff x 2]

w = zeros(size(u,1),size(u,2),size(u,3),2);
w(:,:,:,1) = u([2:end,end],:,:) - u;
w(:,:,:,2) = u(:,[2:end,end],:) - u;
end

