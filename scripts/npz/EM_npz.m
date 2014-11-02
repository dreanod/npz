% EM estimation in a simple case. Meant to test that all the algos are
% correctly implemented.
% The EM algorithm is initialized with the true values. 

rng( 'default' )
clear all
close all

%% Simu parameters

%------------- Model parameters -------------------%

% Known parameters
alpha_phi = .7;
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
ALPHA = [THETA; alpha_phi];

%------------- Observations parameters ---------------%

% Known parameters
C = 2;

%------------- State Variables -----------------%

% Initial values: True values
phi0 = 0.1;
sigma_phi = 0.05; % phi model noise
N0 = .1;
P0 = .1;
Z0 = .01;
X0 = [N0; P0; Z0; phi0];

% Initial NPZ variables
sigma_x = 0.032 * ones(3,1); % CI of ± 5% around model forecast
x0 = log(X0);
sqQ = diag([sigma_x; sigma_phi]);

Nx = size(x0, 1);
T  = 30; % nb of time steps
No = 1;   % size of observations

sigmao = 0.06;           % obs noise deviation, CI of ± 10% around true value
sqR    = sigmao*eye(No); % obs noise covariance
H = zeros(1, Nx); H(2) = 1;
Ne = 50;

npz = @(x, theta) npz_predict(x, theta);
h   = @(x, c) H * x + c;

nIter = 50; % Number of EM iterations

% initialization of EM
xb0 = log(10 * X0);
sqB0 = 0.2 * eye(Nx); % ±30%
sqQ0 = 2 * sqQ;
sqR0 = 2 * sqR;

theta0 = log(2 * THETA);
sqTheta = 0.01 * eye(Ntheta);
%% Generate Observations

[obs, truth] = gen_obs(npz, h, x0, sqQ, sqR, T, THETA, C);

%% EnKS without EM learning

[Xs_EnKS, ~, theta] = EnKS(obs, npz, h, xb0, sqB0, sqQ0, sqR0, Ne, theta, sqTheta, C);

%% EM with EnKS2

[Xs_EM, xb_est, sqB_est, sqQ_est, sqR_est, loglik] = EM(xb0, sqB0, sqQ0, sqR0, npz, h, obs, Ne, nIter, THETA, C);

%% Plot loglikelihood

figure
plot(loglik)

%% Plot truth and estimations

xs_EM = squeeze(mean(Xs_EM, 2));
xs_EnKS = squeeze(mean(Xs_EnKS, 2));

figure
for i=1:4
    subplot(5,1,i)
    plot(truth(i,:), 'g-')
    hold on
    plot(xs_EM(i,:), 'k.')
    plot(xs_EnKS(i,:), 'b.')
    legend('truth', 'EM+EnKS', 'EnKS');
    hold off
end
subplot(5,1,5)
plot(obs, 'g')
hold on
plot(H * xs_EM + C, 'k.')
plot(H * xs_EnKS + C, 'b.')
legend('Obs','EM+EnKS', 'EnKS')
hold off

RMSE_EM   = sqrt(mean2((xs_EM - truth).^2))
RMSE_EnKS = sqrt(mean2((xs_EnKS - truth).^2))