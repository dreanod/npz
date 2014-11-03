rng( 'default' )
clear all
close all

config_npz

%% Generate Observations

[obs, truth] = gen_obs(mod, h, x0, sqQ, sqR, T);

%% EnKS

[Xs, l] = EnKS(obs, mod, h, x0, sqB, sqQ, sqR, Ne);

%%

xs = squeeze(mean(Xs,2));

%%
figure
for i = 1:Nx
    subplot(4,1,i)
    plot(truth(i,:), 'g-')
    hold on
    plot(xs(i,:), 'r.')
    ylabel(i)
    legend('truth','EnKF','EnKS');
    hold off
end

%%
diff2 = (truth - xs).^2;
RMSE_EnKS = sum(diff2(:))/numel(diff2);
disp(['RMSE of EnKS: ', num2str(RMSE_EnKS)]);

