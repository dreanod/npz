function [ obs, truth ] = gen_obs2( mod, H, x0, Q, R, T, No )
%GEN_OBS Summary of this function goes here
%   Detailed explanation goes here

    sqQ = chol(Q);
    sqR = chol(R);
    
    Nx = size(x0, 1);
    
    truth = zeros([Nx, T + 1]);
    x = x0;
    truth(:,1) = x;
    
    obs = zeros([No, T]);

    for t = 1:T
        x = mod(x) + sqQ * randn([Nx, 1]);
        y = H(x) + sqR * randn([No, 1]);

        truth(:, t + 1) = x; 
        obs(:, t) = y;
    end


end

