function [ x ] = transform_state( X )
%TRANSFORM_STATE Summary of this function goes here
%   Detailed explanation goes here
    GAMMA = X(4);
    gamma = log(GAMMA/ (1 - GAMMA));
    
    x = log(X);
    x(4) = gamma;
end

