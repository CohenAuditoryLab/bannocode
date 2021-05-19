function [y] = myGauss(mu,sigma)
% myGauss(mu,sigma) gives Gaussian function whose mean is mu and variance
% is sigma.

x = mu-3*sigma:1:mu+3*sigma;
M = ones(1,length(x)) * mu;
y = 1/((2*pi)^0.5)/sigma * exp(-(x-mu).^2/(2*sigma^2));
end