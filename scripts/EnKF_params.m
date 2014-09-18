rng( 'default' )
clear all
close all

%% Simu parameters

mu    = 2.0;
k     = 0.5;
G     = 1.0;
gamma = 0.9;
ep    = 0.02;
ez    = 0.01;
ep_   = 0.1;
ez_   = 0.1;
theta = [mu; k; G; gamma; ep; ez; ep_; ez_];
c     = 2;

phi0 = 0.1;
x0 = [.1; .1; .01; phi0];
x0 = log(x0);
Nx = size(x0, 1);

T  = 15; % nb of time steps
No = 1; % size of observations
Ne = 30;

sigmao = .1; % obs noise deviation
R      = sigmao^2*eye(No); % obs noise covariance
Q      = 0.01*eye(Nx);

nIter = 10;

R0  = R;
Q0  = Q;
xb0 = x0;
B0  = 0.1 * eye(Nx);

mod = @(x) npz_predict_short(x, theta);
H   = @(x) c + x(2);

%% Generate Observations

[ obs, truth ] = gen_obs( mod, H, x0, Q, R, T );

%% Check observations

figure()
plot(1:T, exp(obs), 'k')
hold on
plot(0:T, exp(truth(1,:)), 'b')
plot(0:T, exp(truth(2,:)), 'g')
plot(0:T, exp(truth(3,:)), 'r')
hold off

%% Store true parameter values

B = .01 * eye(Nx);
[Xa, Xf, ~] = EnKF(obs, mod, H, x0, B, Q, R, Nx, No, T, Ne);

%%
figure
plot(loglik)
title('loglik - EnKS')

xa = squeeze(mean(Xa,2));
xs = squeeze(mean(Xs,2));

%%
figure
for i = 1:Nx
    subplot(7,2,i)
    plot(truth(i,:), 'g-')
    hold on
    plot(xa(i,:), 'r.')
    plot(xs(i,:), 'k.')
    ylabel(i)
    legend('truth','EnKF','EnKS');
    hold off
end

%%
diff2 = (truth - xs).^2;
RMSE_EnKS = sum(diff2(:))/numel(diff2)
