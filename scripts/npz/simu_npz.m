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

% Observation parameter is fixed
c = 2;

% phi evolve with a random walk model
phi0 = 0.1;
sigma_phi = 0.05; % CI of ±8% around previous value.

% Initial NPZ variables
N0 = .1;
P0 = .1;
Z0 = .01;
x0 = [N0; P0; Z0; phi0];
sigma_x = 0.032 * ones(3,1); % CI of ± 5% around model forecast
x0 = log(x0);
sqQ = diag([sigma_x; sigma_phi]);

Nx = size(x0, 1);
T  = 150; % nb of time steps
No = 1;   % size of observations

sigmao = 0.06;           % obs noise deviation, CI of ± 10% around true value
sqR    = sigmao*eye(No); % obs noise covariance
H = zeros(1, Nx); H(2) = 1;
Ne = 100;

npz = @(x, theta) npz_predict(x, theta);
h   = @(x, c) H * x + c;

%% Generate Observations

[obs, truth] = gen_obs(npz, h, x0, sqQ, sqR, T, theta, c);

%% Plot observations

figure()
plot(1:T, exp(obs), '--k')
hold on
plot(0:T, exp(truth(1,:)), 'b')
plot(0:T, exp(truth(2,:)), 'g')
plot(0:T, exp(truth(3,:)), 'r')
plot(0:T, exp(truth(4,:)), 'k')
hold off

