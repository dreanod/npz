function [ xb, sqB, sqQ, sqR ] = maximize( X, obs, h, mod, theta, c)
%MAXIMIZE Summary of this function goes here
%   Detailed explanation goes here
    [~, Ne, T] = size(X);
    No = size(obs, 1);
    T = T-1;
    
    xb = mean(X(:, :, 1), 2);
    B = cov(X(:, :, 1)');
    
    Z = X(:, :, 2:end);
    for t = 1:T
        for i = 1:Ne
            Z(:, i, t) = Z(:, i, t) - mod(X(:, i, t), theta);    
        end
    end
    Z = reshape(Z, [], T * Ne);
    Q = (Z * Z') / (T * Ne);
    
    W = zeros([No, Ne, T]);
    for t = 1:T
        for i = 1:Ne
            W(:, i, t) = obs(:, t) - h(X(:, i, t +1), c);
        end
    end
    W = reshape(W, [], T * Ne);
    R = (W * W') / (T * Ne);

    sqB = chol(B);
    sqR = chol(R);
    sqQ = chol(Q);
end

