function [ xb, sqB, sqQ, sqR ] = maximize( X, obs, h, mod )
%MAXIMIZE Summary of this function goes here
%   Detailed explanation goes here
    [~, Ne, T] = size(X);
    No = size(h, 1);
    T = T-1;
    
    xb = mean(X(:, :, 1), 2);
    B = cov(X(:, :, 1)');
    
    Z = X(:, :, 2:end);
    for t = 1:T
        Z(:, :, t) = Z(:, :, t) - mod(X(:, :, t));    
    end
    Z = reshape(Z, [], T * Ne);
    Q = (Z * Z') / (T * Ne);
    
    W = zeros([No, Ne, T]);
    for t = 1:T
        W(:, :, t) = obs(:, t) - h(X(:, :, t +1));
    end
    W = reshape(W, [], T * Ne);
    R = (W * W') / (T * Ne);

    sqB = chol(B);
    sqR = chol(R);
    sqQ = chol(Q);
end

