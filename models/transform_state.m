function [ x ] = transform_state( X )
%TRANSFORM_STATE Summary of this function goes here
%   Detailed explanation goes here
    GAMMA = X(8);
    gamma = log(GAMMA/ (1 - GAMMA));
    
    x = log(X);
    x(8) = gamma;
end

