function [ENSA, ENSF, GainK] = EnKF(obs, mod, H, xb, B, Q, R, Nx, No, T, Ne)
%ENKF Summary of this function goes here
%   Detailed explanation goes here

    sqB = chol(B);
    sqQ = chol(Q);
    sigmao = sqrt(R);

    ENSA = zeros(Nx, Ne, T + 1);
    ENSF = zeros(Nx, Ne, T);

    % Initialization
    Ensa = zeros(Nx, Ne);
    for i = 1:Ne
        Ensa( :,i ) = xb + sqB * randn( Nx,1 );
    end
    ENSA(:,:,1) = Ensa;

    for t=1:T
        % Forecast
        Ensf = Ensa;
        for i =1:Ne
            Ensf(:,i) = mod(Ensf(:,i)) + sqQ * randn( Nx,1 ); 
        end
        ENSF(:,:,t) = Ensf;

        % Perturb observations
        Y = zeros(No,Ne);
        for i = 1:Ne
            Y(:,i) = obs(:,t) + sigmao * randn(No,1);
        end

        Ensfm = mean(Ensf,2);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

        % Update
        Ensfp = Ensf - repmat(Ensfm,1,Ne);
        Pf = 1/(Ne-1) * (Ensfp * Ensfp');
        GainK = (Pf * H') * (H*Pf*H' + R)^(-1);
        for i =1:Ne
            Ensa(:,i) = Ensf(:,i) + GainK * (Y(:,i) - H*Ensf(:,i));
        end
        ENSA(:,:,t+1) = Ensa;
    end

end

