function [obs, truth] = gen_obs(mod, h, x0, sqQ, sqR, T)
%GEN_OBS Summary of this function goes here
%   Detailed explanation goes here
    
    Nx = size(x0, 1);
    No = size(sqR, 1);
    
    truth = zeros([Nx, T + 1]);
    x = x0;
    truth(:,1) = x;
    
    obs = zeros([No, T]);

    for t = 1:T
        x = mod(x) + sqQ * randn([Nx, 1]);
        y = h(x) + sqR * randn([No, 1]);

        truth(:, t + 1) = x; 
        obs(:, t) = y;
    end


end

