rng( 'default' )
clear all
close all

config_npz

%% Generate Observations

[obs, truth] = gen_obs(mod, h, x0, sqQ, sqR, T);
%% Plot observations

figure()
plot(1:T, exp(obs), '--k')
hold on
plot(0:T, exp(truth(1,:)), 'b')
plot(0:T, exp(truth(2,:)), 'g')
plot(0:T, exp(truth(3,:)), 'r')
plot(0:T, truth(4,:), 'k')
hold off

