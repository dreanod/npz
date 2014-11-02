function [Y] = npz(state, theta, alpha)
%NPZ Summary of this function goes here
%   Detailed explanation goes here
    X = state(1:3);
    phi = state(4);
    x = exp(X);
    y = npz_predict(x, phi, theta);
    Y = [log(y); alpha * phi];
end

