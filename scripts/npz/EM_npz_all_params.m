% EM estimation in a simple case. Meant to test that all the algos are
% correctly implemented.
% The EM algorithm is initialized with the true values. 

rng( 'default' )
clear all
close all

%% Simu parameters

alpha = .9;

% Observation parameter is fixed
C = 2;

% NPZ parameters vary in time. Initial values:
MU    = 2.0;
K     = 0.5;
G     = 1.0;
GAMMA = 0.9;
EP    = 0.02;
EZ    = 0.01;
EP_   = 0.1;
EZ_   = 0.1;
THETA = [MU; K; G; GAMMA; EP; EZ; EP_; EZ_];
sigma_theta = 0.032 * ones(8, 1);

% phi evolve with a random walk model
PHI0 = 0.1;
sigma_phi = 0.05; % CI of ±8% around previous value.

% Initial NPZ variables
N0 = .1;
P0 = .1;
Z0 = .01;
X0 = [N0; P0; Z0; PHI0; THETA];
sigma_x = 0.032 * ones(3,1); % CI of ± 5% around model forecast
x0 = transform_state(X0);
sqQ = diag([sigma_x; sigma_phi; sigma_theta]);

Nx = size(x0, 1);
T  = 30; % nb of time steps
No = 1;   % size of observations

sigmao = 0.06;           % obs noise deviation, CI of ± 10% around true value
sqR    = sigmao*eye(No); % obs noise covariance
H = zeros(1, Nx); H(2) = 1;
Ne = 50;

npz = @(x, alpha) npz_predict_var_params(x, alpha);
h   = @(x, c) H * x + c;

nIter = 50; % Number of EM iterations

% initialization of EM
xb0 = x0;
sqB0 = 0.032 * eye(Nx); % ±5%
sqQ0 = sqQ;
sqR0 = sqR;

%% Generate Observations

[obs, truth] = gen_obs(npz, h, x0, sqQ, sqR, T, alpha, C);

%% EnKS without EM learning

[Xs_EnKS, ~] = EnKS(obs, npz, h, xb0, sqB0, sqQ0, sqR0, Ne, alpha, C);

%% EM with EnKS2

[Xs_EM, xb_est, sqB_est, sqQ_est, sqR_est, loglik] = EM(xb0, sqB0, sqQ0, sqR0, npz, h, obs, Ne, nIter, alpha, C);

%% Plot loglikelihood

figure
plot(loglik)

%% Plot truth and estimations

% xs_EM = squeeze(mean(Xs_EM, 2));
xs_EnKS = squeeze(mean(Xs_EnKS, 2));

figure
for i=1:4
    subplot(5,1,i)
    plot(truth(i,:), 'g-')
    hold on
%     plot(xs_EM(i,:), 'k.')
    plot(xs_EnKS(i,:), 'b.')
    legend('truth', 'EM+EnKS', 'EnKS');
    hold off
end
subplot(5,1,5)
plot(obs, 'g')
hold on
% plot(H * xs_EM + C, 'k.')
plot(H * xs_EnKS + C, 'b.')
legend('Obs','EM+EnKS', 'EnKS')
hold off

% RMSE_EM   = sqrt(mean2((xs_EM - truth).^2))
RMSE_EnKS = sqrt(mean2((xs_EnKS - truth).^2))