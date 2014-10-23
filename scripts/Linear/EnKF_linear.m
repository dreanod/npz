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
sqQ   = .1*eye(3); 

% obs operator
H  = [1,1,1]; 
h = @(x, c) H * x;

sigmao = .1; % obs noise deviation
sqR    = sigmao*eye(No); % obs noise covariance

% initialize EnKF
xb0 = x0;
theta0 = theta * 5;
sqTheta = .1 * eye(Ntheta);
%% Generate observations

[ obs, truth ] = gen_obs( mod, h, x0, sqQ, sqR, T, theta, [] );

%% EM with EnKS2

[Xa, Xf, ~, theta] = EnKF(obs, mod, h, xb0, sqB, sqQ, sqR, Ne, theta0, sqTheta, []);

%%

xa = squeeze(mean(Xa,2));
xf = squeeze(mean(Xf,2));

figure

subplot(3,1,1)
plot(truth(1,:), 'g-')
hold on
plot(xa(1,:), 'r.')
plot(xf(1,:), 'k.')
legend('truth','Analysis','Forecast');
hold off

subplot(3,1,2)
plot(obs, 'bo')
hold on
plot(truth(2,:), 'g-')
plot(xa(2,:), 'r.')
plot(xf(2,:), 'k.')
legend('obs','truth','Analysis', 'Forecast');
hold off

subplot(3,1,3)
plot(truth(3,:), 'g-')
hold on
plot(xa(3,:), 'r.')
plot(xf(3,:), 'k.')
legend('truth','Analysis', 'Forecast');
hold off
title('results - EnKS')

