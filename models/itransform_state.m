function [ X ] = itransform_state( x )
%ITRANSFORM_STATE Summary of this function goes here
%   Detailed explanation goes here
    gamma = x(4);
    GAMMA = exp(gamma)/(1 + exp(gamma));
    
    X = exp(x);
    X(4) = GAMMA;
end

