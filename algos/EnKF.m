function [Xa, Xf, K, theta] = EnKF(obs, f, h, xb, sqB, sqQ, sqR, Ne, thetab, sqTheta, alpha, c)
%ENKF Summary of this function goes here
%   Detailed explanation goes here
    Nx = size(xb, 1);
    No = size(obs, 1);
    T  = size(obs, 2);
    Ntheta = size(thetab, 1);

    Xa = zeros(Nx, Ne, T + 1);
    Xf = zeros(Nx, Ne, T);
    X  = zeros(Nx, Ne);
    Ex = zeros(Nx, Ne);
    Y  = zeros(No, Ne);
    Ey = zeros(No, Ne);
    Theta = zeros(Ntheta, Ne);
    Etheta = zeros(Ntheta, Ne);
    
    % Initialize ensemble
    for i = 1:Ne
        X(:, i) = xb + sqB * randn(Nx, 1);
    end
    Xa(:,:,1) = X;
    
    % Initialize parameter ensemble
    for i = 1:Ne
        Theta(:, i) = thetab + sqTheta * randn(Ntheta, 1);
    end

    for t=1:T
        
        % Forecast
        W = sqQ * randn(Nx, Ne); % model noise
        Z = sqR * randn(No, Ne); % measure noise
        
        for i = 1:Ne
            X(:, i) = f(X(:, i), Theta(:,i), alpha) + W(:, i);
            Y(:, i) = h(X(:, i), c) + Z(:, i);
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
        K = Ex * Ey' * (Ey * Ey')^(-1);
        for i =1:Ne
            X(:, i) = X(:, i) + K * (obs(:, t) - Y(:, i));
        end
        Xa(:, :, t + 1) = X;
        
        % Update parameter
        theta = mean(Theta, 2);
        for i = 1:Ne
            Etheta(:, i) = Theta(:, i) - theta;
        end
        Etheta = Etheta / sqrt(Ne - 1);
        Ktheta = Etheta * Ey'* (Ey * Ey')^(-1);
        for i=1:Ne
            Theta(:, i) = Theta(:, i) + Ktheta * (obs(:, t) - Y(:, i));
        end
    end
    theta = mean(Theta, 2);
end

