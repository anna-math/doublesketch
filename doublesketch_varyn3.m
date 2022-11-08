close all
clc
clear

rng(1)

addpath('utils')

r0 = 10;
nn = 100;
eps1 = 0.01;
eps2 = 0.01;

saveBoo = true
%eps1Vec = 0:.002:.1;
%eps2Vec =  0:.002:.1;

r1Vec = [11 20 90];
n3Vec = 1:10:100;
numTrials = 50;

figure
figure('DefaultAxesFontSize',16)
set(0, 'defaultlinelinewidth',3)
hold on

for kk = 1:length(r1Vec)
    r1 = r1Vec(kk)
    kk
    for ii = 1:length(n3Vec)
        n3 = n3Vec(ii);
        ii

        X0 = tprod(randn(nn,r0,n3), randn(r0,nn,n3));
        X0 = X0 ./tnorm(X0);

        errTrials = zeros(numTrials,1);
        for tt = 1:numTrials

            tensor=false;
            if(n3 > 1)
                tensor = true;
            end

            % Noisy Sketch
            [YY, Ytilde, SS] = dsSketch(X0, r1, eps1, eps2);

            % Transform
            if(tensor)
                YY = fft(YY, [], 3);
                Ytilde = fft(Ytilde, [], 3);
                SS = fft(SS, [], 3);
            end

            % Recover
            X1 = dsRecovery(YY, Ytilde, SS);
            if(tensor)
                X1 = ifft(X1, [], 3);
            end

            errTrials(tt) = tnorm(X1 - X0);
        end

        err(ii) = median(errTrials);

    end

plot(n3Vec, err, 'DisplayName', sprintf('r=%d', r1))
end

legend('show')
xlabel('n_3')
ylabel('Approximation Error')
xlim([1 100])


if(saveBoo)
    set(gcf,'WindowStyle','normal'); 
    set(gcf,'PaperPositionMode','Auto');
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 6 5]); 
    fname = sprintf('%s_%dnn_%drr_final', mfilename(pwd), nn, r0);
    saveFigure(strcat(fname ,'.fig'))
    saveas(gcf, strcat(fname ,'.png'))
end







