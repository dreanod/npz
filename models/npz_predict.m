function [ Y ] = npz_predict(X)
%NPZ_PREDICT Summary of this function goes here
%   Detailed explanation goes here
    x = exp(X); % inverse log transformation
    x(8) = exp(X(8)/(exp(X(8)) + 1)); % inverse logit transformation
    
    y0 = x(1:3);
    phi = x(4);
    theta = x(5:end);
    
    odefun = @(t, x) npz_f(x, phi, theta);

    tspan = 0:1;

    [~, y] = ode45(odefun,tspan,y0);
    y = y(end,:)';
    y = log(y); % log transformation
    Y = X;
    Y(1:3) = y;
    
end


function [df] = npz_f(x, phi, theta)
    mu = theta(1); k = theta(2); G = theta(3); gamma = theta(4);
    ep = theta(5); ez = theta(6); ep_ = theta(7); ez_ = theta(8);

    N = x(1); P = x(2); Z = x(3);

    f  = 1;
    g  = mu * N / ( k + N );
    h  = G * P;
    i  = ep;
    i_ = ep_ * P;
    j  = ez;
    j_ = ez_ * Z;

    dP = f * g * P - h * Z - ( i + i_ ) * P ;
    dZ = gamma * h * Z - ( j + j_ ) * Z;
    dN = - f * g * P - ( 1 - gamma ) * h * Z + i * P + j * Z + phi;

    df = [ dN; dP; dZ ];

end