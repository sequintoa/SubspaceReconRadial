function y = shrinkage1(a, kappa)
% MATLAB scripts for alternating direction method of multipliers
% S. Boyd, N. Parikh, E. Chu, B. Peleato, and J. Eckstein
% https://web.stanford.edu/~boyd/papers/admm/total_variation/total_variation.html

y = max(0, a-kappa) - max(0, -a-kappa);

return