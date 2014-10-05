% EM estimation in a simple case. Meant to test that all the algos are
% correctly implemented.
% The EM algorithm is initialized with the true values. 

rng( 'default' )
clear all
close all

%% Simu parameters

% NPZ parameters are fixed.
MU    = 2.0;
K     = 0.5;
G     = 1.0;
GAMMA = 0.9;
EP    = 0.02;
EZ    = 0.01;
EP_   = 0.1;
EZ_   = 0.1;
THETA = [MU; K; G; GAMMA; EP; EZ; EP_; EZ_];

% Observation parameter is fixed
C = 2;

% phi evolve with a random walk model
PHI0 = 0.1;
sigma_phi = 0.05; % CI of ±8% around previous value.

% Initial NPZ variables
N0 = .1;
P0 = .1;
Z0 = .01;
X0 = [N0; P0; Z0; PHI0];
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

nIter = 30; % Number of EM iterations

% initialization of EM
xb0 = log(2 * X0);
sqB0 = 0.06 * eye(Nx);
sqQ0 = 1.1 * sqQ;
sqR0 = 1.1 * sqR;

%% Generate Observations

[obs, truth] = gen_obs(npz, h, x0, sqQ, sqR, T, THETA, C);

%% EM with EnKS2

[Xs, xb_est, sqB_est, sqQ_est, sqR_est, loglik] = EM(xb0, sqB0, sqQ0, sqR0, npz, h, obs, Ne, nIter, THETA, C);

%%

plot(loglik)

%%
xs = squeeze(mean(Xs, 2));

figure
for i=1:4
    subplot(5,1,i)
    plot(truth(i,:), 'g-')
    hold on
    plot(xs(i,:), 'k.')
    legend('truth', 'EnKS');
    hold off
end
subplot(5,1,5)
plot(obs, 'ob')
hold on
plot(H * xs + C, 'g')
legend('Obs','smoothing')
hold off

