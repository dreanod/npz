function [ENSS] = EnKS(ENSA, ENSF, Nx, T, Ne)
%ENKS Summary of this function goes here
%   Detailed explanation goes here


ENSS = zeros(Nx, Ne, T+1);
Enss = ENSA(:,:,end);
ENSS(:,:,end) = Enss;
 
for t=T-1:-1:0
    Ensf = zeros(Nx,Ne);
    Ensf(:,:) = ENSF(:,:,t+1);
    Ensfm = mean(Ensf,2);
    Ensfp = Ensf - repmat(Ensfm,1,Ne);
    
    Ensa = zeros(Nx,Ne);
    Ensa(:,:) = ENSA(:,:,t+1);
    Ensam = mean(Ensa,2);
    Ensap = Ensa - repmat(Ensam,1,Ne);
    
    K = Ensap*Ensfp'/(Ensfp*Ensfp');
    
    for i=1:Ne
        Enss(:,i) = Ensa(:,i) + K*(Enss(:,i) - Ensf(:,i));
    end
    ENSS(:,:,t+1) = Enss; 
end

end
