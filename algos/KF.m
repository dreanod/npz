function [xa, Pf, xf, Pa, K, lik] = KF(obs, M, H, xb, B, Q, R, Nx, T)
    %KF Summary of this function goes here
    %   Detailed explanation goes here

    xa = zeros(Nx,T+1); % xa(:,1) corresponds to 0th timestep
    xf = zeros(Nx,T);
    Pa = zeros(Nx,Nx,T,+1); % same as xa
    Pf = zeros(Nx,Nx,T);

    % Initialization
    x = xb;
    P = B;
    xa(:,1) = x;
    Pa(:,:,1) = P;
    lik = 0;
    for t=1:T
        % Forecast
        x = M*x;
        P = M*P*M' + Q;

        xf(:,t) = x;
        Pf(:,:,t) = P;

        % Update
        sig = H*P*H' + R;
        sig = .5*(sig+sig');
        siginv = inv(sig);
        innov = obs(t) - H*x;
        K = P*H'*siginv;
        x = x + K*innov;
        P = P - K*H*P;

        xa(:,t+1) = x;
        Pa(:,:,t+1) = P;
        lik = lik + log(det(sig)) + innov'*siginv*innov;
    end
    lik = .5*lik;
    
end

