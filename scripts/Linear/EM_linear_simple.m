% Simple EM case to test if algos correctly implemented. The EM is
% initialized with the true values. 

rng( 'default' )
clear all

%% Simu parameters

T  = 150; % nb of time steps
No = 1; % size of observations
Nx = 3; % size of state
Ne = 100;

x0 = ones(Nx,1); % background mean
sqB = .1 * eye(Nx);

% propagation operator
theta1 = .1; theta2 = .1;
theta = [theta1; theta2];
Ntheta = size(theta, 1);
mod = @(x, theta)  linear_rot(x, theta(1), theta(2));

% model noise covariance
sqQ   = 0.1*eye(3); 

% obs operator
H  = [0,1,0]; 
h = @(x, c) H * x;

sigmao = .1; % obs noise deviation
sqR      = sigmao^2*eye(No); % obs noise covariance

nIter = 10;
theta0 = theta * 5;
sqTheta = 0.1 * eye(Ntheta);

%% Generate observations

[ obs, truth ] = gen_obs( mod, h, x0, sqQ, sqR, T, theta, [] );

%% EM with EnKS2

[Xs, xb, sqB, sqQ, sqR, loglik, theta] = EM(x0, sqB, sqQ, sqR, mod, h, obs, Ne, nIter, theta0, sqTheta, []);

%%

figure
plot(loglik)

%%
xs = squeeze(mean(Xs, 2));

figure
subplot(3,1,1)
plot(truth(1,:), 'g-')
hold on
plot(xs(1,:), 'k.')
legend('truth', 'EnKS');
hold off

subplot(3,1,2)
plot(obs, 'bo')
hold on
plot(truth(2,:), 'g-')
plot(xs(2,:), 'k.')
legend('obs','truth','EnKS');
hold off

subplot(3,1,3)
plot(truth(3,:), 'g-')
hold on
plot(xs(3,:), 'k.')
legend('truth', 'EnKS');
hold off
title('results - EnKS')

