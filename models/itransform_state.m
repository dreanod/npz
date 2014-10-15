function [ X ] = itransform_state( x )
%ITRANSFORM_STATE Summary of this function goes here
%   Detailed explanation goes here
    gamma = x(8);
    GAMMA = exp(gamma)/(1 + gamma);
    
    X = exp(x);
    X(8) = GAMMA;
end

