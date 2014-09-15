function [ Xs, xb, B, Q, R, loglik ] = ...
                EM(xb0, B0, Q0, R0, mod, H, obs, Ne, nIter)
%EM Summary of this function goes here
%   Detailed explanation goes here

    loglik = zeros(nIter,1);

    R  = R0;
    Q  = Q0;
    xb = xb0;
    B  = B0;
    
    [No, T] = size(obs);
    Nx = size(xb, 1);

    for k=0:nIter

        % E-step
        [Xa, Xf, ~] = EnKF(obs, mod, H, xb, B, Q, R, Nx, No, T, Ne);
        xf = squeeze(mean(Xf, 2));
        Pf = zeros(Nx, Nx, T);
        for t=1:T
            Pf(:,:,t) = cov(Xf(:,:,t)');
        end
        loglik(k+1) = likelihood(obs, H, R, xf, Pf, T);
        Xs = EnKS(Xa, Xf, Nx, T, Ne);

        % M-step
        [ xb, B, Q, R ] = maximize( Xs, obs, H, mod );

    end
end

