function [Y] = npz(state, params)
%NPZ Summary of this function goes here
%   Detailed explanation goes here
    X = state(1:3);
    phi = state(4);

    THETA = params(1:end-1);
    alpha = params(end);
    
    x = exp(X);
    theta = itransform_state(THETA);
    
    y = npz_predict(x, phi, theta);

    Y = [log(y); alpha * phi];
end

