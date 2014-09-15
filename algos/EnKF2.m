function [Xa, Xf, K] = EnKF2(obs, f, h, xb, sqB, sqQ, sqR, Ne)
%ENKF Summary of this function goes here
%   Detailed explanation goes here
    Nx = size(xb, 1);
    No = size(obs, 1);
    T  = size(obs, 2);

    Xa = zeros(Nx, Ne, T + 1);
    Xf = zeros(Nx, Ne, T);
    X  = zeros(Nx, Ne);
    Ex = zeros(Nx, Ne);
    Y  = zeros(No, Ne);
    Ey = zeros(No, Ne);
    
    % Initialize ensemble
    for i = 1:Ne
        X(:, i) = xb + sqB * randn(Nx, 1);
    end
    Xa(:,:,1) = X;

    for t=1:T
        
        % Forecast
        W = sqQ * randn(Nx, Ne); % model noise
        Z = sqR * randn(No, Ne); % measure noise
        
        for i = 1:Ne
            X(:, i) = f(X(:, i)) + W(:, i);
            Y(:, i) = h(X(:, i)) + Z(:, i);
        end
        Xf(:,:,t) = X;
        
        Xmean = mean(X, 2);
        for i = 1:Ne
            Ex(:, i) = X(:, i) - Xmean;
        end
        Ex = Ex / sqrt(Ne - 1);
        
        Ymean = mean(Y, 2);
        for i = 1:Ne
            Ey(:, i) = Y(:, i) - Ymean;
        end
        Ey = Ey / sqrt(Ne - 1);
        
            
        % Update
        K = Ex * Ey' * (Ey * Ey' + sqR * sqR')^(-1);
        for i =1:Ne
            X(:, i) = X(:, i) + K * (obs(:, t) - Y(:, i));
        end
        Xa(:, :, t + 1) = X;
    end

end

