function [kvec, W] = generateRadialTraj(theta, steps, useVoronoiDens)
% Generate a radial trajectory to be used with NUFFT operator
%
% Mahesh Keerthivasan, 2016
% University of Arizona


if nargin < 3
    useVoronoiDens = 0;
end

% xtraj = ((0:steps-1) - steps/2.0) / steps;
% ytraj = ((0:steps-1) - steps/2.0) / steps;

xtraj = linspace(-.5,.5,steps);
ytraj = xtraj;

numAngles = length(theta);
kspace = complex(zeros(steps,numAngles));
for j=1:numAngles
    for i=1 : steps
        kx = cos( theta(j) ) * xtraj(i);
        ky = sin( theta(j) ) * ytraj(i);
        kspace(i,j) = complex(kx,ky);
    end
end
kvec = kspace(:);


% Weights: 
% option 1
W = abs(kvec)./(2*max(abs(kvec)));


% Option 2: non voronoidens
% kx = linspace(-.5,.5,steps);
% W = zeros(size(kvec,1),1);
% for p=1:numAngles
%     W((p-1)*numel(kx)+(1:numel(kx))) = abs(kx);
% end
% W = W .* (numel(W/sum(W(:))));
% area_weights = pi*(0.5)^2; %Fraction of k-space covered
% W = W .* (area_weights/sum(W(:)));


% % if voronoidens
if useVoronoiDens
    W = voronoidens(kvec);
    W = W(:)/max(abs(W(:))) ;
end

end