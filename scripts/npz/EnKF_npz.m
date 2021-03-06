rng( 'default' )
clear all
close all

config_npz

%% Generate Observations

[obs, truth] = gen_obs(mod, h, x0, sqQ, sqR, T);

%% EnKF

[Xa, Xf, K] = EnKF(obs, mod, h, xb, sqB, sqQ, sqR, Ne);

%%

xa = squeeze(mean(Xa,2));

%%
figure
for i = 1:Nx
    subplot(4,1,i)
    plot(truth(i,:), 'g-')
    hold on
    plot(xa(i,:), 'r.')
    ylabel(i)
    legend('truth','EnKF','EnKS');
    hold off
end

%%
diff2 = (truth - xa).^2;
RMSE_EnKS = sum(diff2(:))/numel(diff2);
disp(['RMSE EnKS: ', num2str(RMSE_EnKS)])
