function [Xs] = EnKS2(obs, mod, H, x0, sqB, sqQ, sqR, Ne)
%ENKS Summary of this function goes here
%   Detailed explanation goes here
    [Xa, Xf, ~] = EnKF2(obs, mod, H, x0, sqB, sqQ, sqR, Ne);
    
    [Nx, Ne, T] = size(Xf);
  
    Xs = zeros(Nx, Ne, T+1);
    X = Xa(:,:,end);
    Xs(:,:,end) = X;

    for t=T-1:-1:0
        Ensf = Xf(:, :, t + 1);
        Ensfm = mean(Ensf,2);
        Ensfp = Ensf - repmat(Ensfm,1,Ne);

        Ensa = Xa(:, :, t + 1);
        Ensam = mean(Ensa,2);
        Ensap = Ensa - repmat(Ensam,1,Ne);

        K = Ensap*Ensfp'/(Ensfp*Ensfp');

        for i=1:Ne
            X(:,i) = Ensa(:,i) + K*(X(:,i) - Ensf(:,i));
        end
        Xs(:,:,t+1) = X; 
    end

end
