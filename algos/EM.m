function [ Xs, xb, sqB, sqQ, sqR, loglik ] = ...
                EM(xb0, sqB0, sqQ0, sqR0, mod, H, obs, Ne, nIter,theta,c)
%EM Summary of this function goes here
%   Detailed explanation goes here

    loglik = zeros(nIter,1);

    sqR  = sqR0;
    sqQ  = sqQ0;
    xb = xb0;
    sqB  = sqB0;

    for k=1:nIter

        % E-step      
        [Xs, l] = EnKS(obs, mod, H, xb, sqB, sqQ, sqR, Ne, theta, c);
        loglik(k) = l;
        
        % M-step
        [ xb, sqB, sqQ, sqR ] = maximize( Xs, obs, H, mod, theta, c );

    end
end

