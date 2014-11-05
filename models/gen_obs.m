function [obs, truth] = gen_obs(mod, h, x0, sqQ, sqR, T, theta, c)
%GEN_OBS Generate observations from the models
%   mod: function for the model of the form X_t = mod(X_{t-1}, theta,
%   alpha)
%   h: function that generate the observation of the form Y_t = h(X_t, c)
%   x0: initial state
%   sqQ: square root of the model noise
%   sqR: square root of the measurement model
%   T: number of time steps
%   theta: model unknown parameters
%   alpha: model known parameters
%   c: measurement known parameters
    
    Nx = size(x0, 1);
    No = size(sqR, 1);
    
    truth = zeros([Nx, T + 1]);
    x = x0;
    truth(:,1) = x;
    
    obs = zeros([No, T]);

    for t = 1:T
        x = mod(x, theta) + sqQ * randn([Nx, 1]);
        y = h(x, c) + sqR * randn([No, 1]);

        truth(:, t + 1) = x; 
        obs(:, t) = y;
    end


end

