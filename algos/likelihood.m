function [l] = likelihood(Xf, obs, h, sqR, c)
%LIKELIHOOD Summary of this function goes here
%   Detailed explanation goes here

    [~, Ne, T] = size(Xf);
    No = size(obs, 1);

    l=0;
    x = mean(Xf, 2);
    Y = zeros(No, Ne);
    for t=1:T
        innov = obs(t) - h(x(:,t), c);
        for i = 1:Ne
            Y(:, i) = h(Xf(:, i, t), c);
        end
        Ymean = mean(Y, 2);
        for i = 1:Ne
            Y(:, i) = Y(:, i) - Ymean;
        end
        sig = Y * Y' + sqR*sqR';
        sig = .5*(sig + sig');
        siginv = inv(sig);
        l = l + log(det(sig)) + innov'*siginv*innov;
    end
    l = l/2;
end

