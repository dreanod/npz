rng( 'default' )
clear all

%% Simu parameters

T  = 150; % nb of time steps
No = 1; % size of observations
Nx = 3; % size of state
Ne = 100;

x0 = ones(Nx,1); % background mean
B = .1 * eye(Nx);

% propagation operator
theta1 = .1; theta2 = .1;
mod = @(x)  linear_rot(x, theta1, theta2);

% model noise covariance
Q   = 0.01*eye(3); 

% obs operator
H  = [0,1,0]; 
H = @(x) H * x;

sigmao = .1; % obs noise deviation
R      = sigmao^2*eye(No); % obs noise covariance

%% Generate observations

[ obs, truth ] = gen_obs2( mod, H, x0, Q, R, T, No );

%% EM with EnKS2
sqB = chol(B);
sqR = chol(R);
sqQ = chol(Q);

Xs = EnKS2(obs, mod, H, x0, sqB, sqQ, sqR, Ne);

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

