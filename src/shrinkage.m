function y = shrinkage(a, kappa)

y = sign(a) .* max(abs(a) - kappa, 0);

end