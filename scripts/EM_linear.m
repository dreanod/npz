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

nIter = 50;

%% Generate observations

[ obs, truth ] = gen_obs( mod, H, x0, Q, R, T, No );

%% EM with EnKS2
R = 10;
Q = 1*eye(3);
xb0 = zeros(3,1);
B = eye(3);

sqB0 = chol(B);
sqR0 = chol(R);
sqQ0 = chol(Q);


[Xs, xb, sqB, sqQ, sqR, loglik] = EM(xb0, sqB0, sqQ0, sqR0, mod, H, obs, Ne, nIter);

%%

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

