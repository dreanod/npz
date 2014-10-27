rng( 'default' )
clear all
close all

%% Simu parameters

% Unknown Model Parameters ------------------------------------------------

% NPZ parameters
MU    = 2.0;
K     = 0.5;
G     = 1.0;
GAMMA = 0.9;
EP    = 0.02;
EZ    = 0.01;
EP_   = 0.1;
EZ_   = 0.1;

THETA = [MU; K; G; GAMMA; EP; EZ; EP_; EZ_];
theta = transform_state(THETA);

% First Guess
theta0 = transform_state(THETA);
sqTheta = 0.006 * ones(size(theta, 1)); 

% Known Model Parameters --------------------------------------------------

% Phi Auto-Regressive Coefficient
alpha = .7;

% Known Observations Parameters -------------------------------------------

% Conversion rate phytoplankton -> Chl
C = 2;
c = log(C);

% State Initialization ---------------------------------------------------

% Truth
phi0 = 0.1;
N0 = .1;
P0 = .1;
Z0 = .01;
x0 = [log(N0); log(P0); log(Z0); phi0];
Nx = size(x0, 1); % nb of state

% First Guess
sqB = 0.05 * eye(Nx);
x0 = x0 * 1.05;

% Model function ----------------------------------------------------------

npz = @(x, theta, alpha) npz_predict2(x, theta, alpha);

% Observation function ----------------------------------------------------

H = zeros(1, Nx); H(2) = 1;
h   = @(x, c) H * x + c;
No = 1;   % nb of obs

% True Model Noise --------------------------------------------------------

sigma_phi = 0.05; % phi model noise
sigma_x = 0.032 * ones(3,1); % CI of ± 5% around model forecast
sqQ = diag([sigma_x; sigma_phi]);

% True Observation noise --------------------------------------------------

sigmao = 0.06;           % obs noise deviation, CI of ± 10% around true value
sqR    = sigmao*eye(No); % obs noise covariance

% Simulation parameters ---------------------------------------------------

T  = 30; % nb of time steps

% Ensemble parameters -----------------------------------------------------

Ne = 100; % Ensemble size

%% Generate Observations

[obs, truth] = gen_obs(npz, h, x0, sqQ, sqR, T, theta, alpha, c);

%% EnKF

[Xa, Xf, K, theta] = EnKF(obs, npz, h, x0, sqB, sqQ, sqR, Ne, theta0, sqTheta, alpha, c);

%%

xa = squeeze(mean(Xa,2));

%%
figure
for i = 1:Nx
    subplot(4,1,i)
    plot(truth(i,:), 'g-')
    hold on
    plot(xa(i,:), 'r.')
    ylabel(i)
    legend('truth','EnKF','EnKS');
    hold off
end

%%
diff2 = (truth - xa).^2;
RMSE_EnKS = sum(diff2(:))/numel(diff2);
disp(['RMSE EnKS', num2str(RMSE_EnKS)])
