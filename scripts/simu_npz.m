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

mod = @(x) npz_predict(x);
h   = @(x) H * x;

%% Generate Observations

[ obs, truth ] = gen_obs( mod, h, X0, sqQ, sqR, T );

%% Plot observations

figure()
plot(1:T, exp(obs), '--k')
hold on
plot(0:T, exp(truth(1,:)), 'b')
plot(0:T, exp(truth(2,:)), 'g')
plot(0:T, exp(truth(3,:)), 'r')
plot(0:T, exp(truth(4,:)), 'k')
hold off

