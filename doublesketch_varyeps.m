close all
clc
clear

addpath('utils')

r0 = 10;
nn = 100;
n3 = 1;

X0 = tprod(randn(nn,r0,n3), randn(r0,nn,n3));


eps1Vec = 0:.002:.1;
eps2Vec =  0:.002:.1;
r1Vec = [11 20 99];
numTrials = 50;

figure
figure('DefaultAxesFontSize',16)


tensor=false;
if(n3 > 1)
    tensor = true;
end

for kk = 1:length(r1Vec)
    r1 = r1Vec(kk)
    kk
    for ii = 1:length(eps1Vec)
        ii
        for jj = 1:length(eps2Vec)
            jj
            eps1 = eps1Vec(ii);
            eps2 = eps2Vec(jj);

            errTrials = zeros(numTrials,1);
            for tt = 1:numTrials

                % Noisy Sketch
                Z1 = randn(r1,nn,n3);
                Z1 = Z1 ./ tnorm(Z1) * eps1;
                Z2 = randn(r1,nn,n3);
                Z2 = Z2 ./ tnorm(Z2) * eps2;
                [YY, Ytilde, SS] = dsSketch(X0, r1, Z1, Z2);

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

            err(jj,ii) = median(errTrials);
            %sigs = svd(X0);
            %err_bnd(jj,ii) = sqrt(r1*(nn-r1))/(sqrt(r1) - sqrt(rr)) * norm(Z2) + sqrt(r1) * norm(Z1);
            
        end
    end


subplot(1,length(r1Vec),kk)
imagesc(fliplr(err')')
xlabel('\epsilon_1')
ylabel('\epsilon_2')
xticks(5:15:length(eps1Vec))
yticks(4:15:length(eps2Vec))
xticklabels(eps1Vec(5:15:length(eps1Vec)))
yticklabels(fliplr(eps2Vec(4:15:length(eps2Vec))))
maxX = median(err(:));
caxis([0,.2])
colorbar

%figure
%imagesc(fliplr(err_bnd')')
%xlabel('\epsilon_1')
%ylabel('\epsilon_2')
%xticklabels(eps1Vec(5:5:length(eps1Vec)))
%yticklabels(fliplr(eps2Vec(2:4:length(eps2Vec))))
%caxis([0,2])
%colorbar

%% Save plot
%set(gcf,'WindowStyle','normal'); 
%set(gcf,'PaperPositionMode','Auto');
%set(gcf, 'PaperUnits', 'inches');
%set(gcf, 'PaperPosition', [0 0 6 5]); 
%fname = sprintf('%s_%dnn_%drr_%dr1_errbnd', mfilename(pwd), nn, rr, r1);
%saveFigure(strcat(fname ,'.fig'))
%saveas(gcf, strcat(fname ,'.png'))
%save(strcat('data/',fname, '.mat'));

%figure
%set(0, 'defaultlinelinewidth', 2)
%set(0,'defaultAxesFontSize', 16)
%markers = {'--+', '-.*', '-+'};
%subplot(1,2,2)
%title('\epsilon_1 = 0')
%plot(eps2Vec, err_bnd(:,1),'DisplayName', 'Error Bound')
%hold on
%plot(eps2Vec, err(:,1), 'DisplayName', 'Empirical Error')
%plot(eps2Vec, err_bnd2(:,1),'DisplayName', 'Error Bound Conj')
%xlabel('\epsilon_2')
%ylabel('Approximation Error')
%legend('show')

%subplot(1,2,1)
%title('\epsilon_2 = 0')
%plot(eps1Vec, err_bnd(1,:),'DisplayName', 'Error Bound')
%hold on
%plot(eps1Vec, err(1,:), 'DisplayName', 'Empirical Error')
%plot(eps1Vec, err_bnd2(1,:),'DisplayName', 'Error Bound Conj')
%xlabel('\epsilon_1')
%ylabel('Approximation Error')
%legend('show')
    
%% Save plot
%set(gcf,'WindowStyle','normal'); 
%set(gcf,'PaperPositionMode','Auto');
%set(gcf, 'PaperUnits', 'inches');
%set(gcf, 'PaperPosition', [0 0 11 5]); 
%fname = sprintf('%s_%dnn_%drr_%dr1_epsverr', mfilename(pwd), nn, rr, r1);
%saveFigure(strcat(fname ,'.fig'))
%saveas(gcf, strcat(fname ,'.png'))
%save(strcat('data/',fname, '.mat'));
    
end


%% Save plot
set(gcf,'WindowStyle','normal'); 
set(gcf,'PaperPositionMode','Auto');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [0 0 20 5]); 
fname = sprintf('%s_%dnn_%dn3_%drr_final', mfilename(pwd), nn, n3, r0);
saveFigure(strcat(fname ,'.fig'))
saveas(gcf, strcat(fname ,'.png'))
%save(strcat('data/',fname, '.mat'));






