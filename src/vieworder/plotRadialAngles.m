function plotRadialAngles(theta)
% Plot the radial angles 'theta' using polar cooradinates
% Useful to visualize radial view orderings and coverage
% Assumes rho = 1, always.
% Input : theta - angles in radians
%
% Mahesh Keerthivasan,
% March 2017

theta = [theta; theta(1)];

nFrames = length(theta);
% Preallocate movie structure.
mov(1:nFrames) = struct('cdata', [],...
                        'colormap', []);

rho = [1 1];
figure('Name','View Order');
set(gcf,'Color','white');


for idx = 1 : length(theta)
    hold on;
    h1 = polar([theta(idx) theta(idx)+pi], rho, '-b');
    set(h1,'linewidth',2)
    hold on;
    axis square off
    mov(idx) = getframe(gcf);
    pause(0.02);
end
% hold on;

% movie2avi(mov, 'tmp.avi', 'compression', 'None','fps',5);


end