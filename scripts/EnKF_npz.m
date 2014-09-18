rng( 'default' )
clear all
close all

%% Simu parameters

% NPZ parameters are fixed.
mu    = 2.0;
k     = 0.5;
G     = 1.0;
gamma = 0.9;
ep    = 0.02;
ez    = 0.01;
ep_   = 0.1;
ez_   = 0.1;
theta = [mu; k; G; gamma; ep; ez; ep_; ez_];
sigma_theta = zeros(size(theta));

% Observation parameter is fixed
c     = 2;
sigma_c = 0;

% phi evolve with a random walk model
phi0 = 0.1;
sigma_phi = 0.05; % CI of ±8% around previous value.

% Initial NPZ variables
x0 = [.1; .1; .01];
sigma_x = 0.032 * ones(3,1); % CI of ± 5% around model forecast

X0 = [x0; phi0; theta; c];
X0 = log(X0);
sigma = [sigma_x; sigma_phi; sigma_theta; sigma_c];
sqQ = diag(sigma);

Nx = size(X0, 1);
T  = 150; % nb of time steps
No = 1; % size of observations
Ne = 30;

sigmao = 0.06; % obs noise deviation, CI of ± 10% around true value
sqR      = sigmao*eye(No); % obs noise covariance
H = zeros(1, Nx); H(2) = 1; H(end) = 1;

npz = @(x) npz_predict(x);
h   = @(x) H * x;

%% Generate Observations

[obs, truth] = gen_obs(npz, h, X0, sqQ, sqR, T);

%% EnKF

Ne = 100;
sqB = 0.05 * eye(Nx);
X0 = X0 * 1.05;

[Xa, Xf, K] = EnKF(obs, npz, h, X0, sqB, sqQ, sqR, Ne);

%%

xa = squeeze(mean(Xa,2));

%%
figure
for i = 1:Nx
    subplot(7,2,i)
    plot(truth(i,:), 'g-')
    hold on
    plot(xa(i,:), 'r.')
    ylabel(i)
    legend('truth','EnKF','EnKS');
    hold off
end

%%
diff2 = (truth - xs).^2;
RMSE_EnKS = sum(diff2(:))/numel(diff2)

