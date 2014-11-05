function [ y ] = npz(state, theta, alpha)
%NPZ Summary of this function goes here
%   Detailed explanation goes here

    phi = state(end);
    x = exp(state(1:3));
    npz_params = itrans(theta);
    
    
    y = npz_predict(x, phi, npz_params);
    
    y = [log(y); alpha * phi];

end

function [ X ] = itrans( x )
%ITRANSFORM_STATE Summary of this function goes here
%   Detailed explanation goes here
    gamma = x(4);
    GAMMA = exp(gamma)/(1 + exp(gamma));
    
    X = exp(x);
    X(4) = GAMMA;
end

