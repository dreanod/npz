function [l] = likelihood(obs, H, R, x, P, T)
%LIKELIHOOD Summary of this function goes here
%   Detailed explanation goes here

l=0;
for t=1:T
    innov = obs(t) - H*x(:,t);
    sig = H*P(:,:,t)*H' + R;
    sig = .5*(sig + sig');
    siginv = inv(sig);
    l = l + log(det(sig)) + innov'*siginv*innov;
end

l = l/2;
end

