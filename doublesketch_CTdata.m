close all
clc
clear

addpath('utils')
load CTdata.mat 

eps1 = 0.01;
eps2 =  0.01;
rr = 200;
numTrials = 50;
saveBoo = false;

XX = XX ./ tnorm(XX);
[n1,n2,n3] = size(XX);



%% AS TENSOR 
errTensor = [];
for tt = 1:numTrials
	% Noisy Sketch
    Z1 = randn(rr,n2,n3);
    Z1 = Z1 ./ tnorm(Z1) * eps1;
    Z2 = randn(rr,n1,n3);
    Z2 = Z2 ./ tnorm(Z2) * eps2;
	[YY, Ytilde, SS] = dsSketch(XX, rr, Z1, Z2);

	% Transform
	YY = fft(YY, [], 3);
	Ytilde = fft(Ytilde, [], 3);
	SS = fft(SS, [], 3);

	% Recover
	X1Tensor = dsRecovery(YY, Ytilde, SS);
	X1Tensor = ifft(X1Tensor, [], 3);

	errTensor(tt) = tnorm(X1Tensor - XX);
end
median(errTensor)

%% AS MATRIX 
errMat = [];
for tt=1:numTrials
    X1Matrix = zeros(n1,n2,n3);
    % Noisy Sketch
    Z1 = randn(rr,n2,n3);
    Z1 = Z1 ./ tnorm(Z1) * eps1;
    Z2 = randn(rr,n1,n3);
    Z2 = Z2 ./ tnorm(Z2) * eps2;
    for ii = 1:n3
        [YY, Ytilde, SS] = dsSketch(XX(:,:,ii), rr, Z1(:,:,ii), Z2(:,:,ii));
        Xi = dsRecovery(YY, Ytilde, SS);
        X1Matrix(:,:,ii) = Xi;
    end

    errMat(tt) = tnorm(X1Matrix - XX);
end
median(errMat)



%% FIXED SKETCHING MATRIX 
errMatFixed = [];
for tt=1:numTrials
    X1MatrixFixed = zeros(n1,n2,n3);
    % fix the sketch
    SS = randn(rr,n1);
    St = randn(rr,n2);
    Z1 = randn(rr,n2,n3);
    Z1 = Z1 ./ tnorm(Z1) * eps1;
    Z2 = randn(rr,n1,n3);
    Z2 = Z2 ./ tnorm(Z2) * eps2;
    for ii = 1:n3
        YY = SS * XX(:,:,ii) + Z1(:,:,ii);
        Ytilde = St * XX(:,:,ii)' + Z2(:,:,ii);
        Xi = dsRecovery(YY, Ytilde, SS);
        X1MatrixFixed(:,:,ii) = Xi;
    end
    errMatFixed(tt) = tnorm(X1MatrixFixed - XX);
end
median(errMatFixed)




figure('DefaultAxesFontSize',16)
slicesVec = [20]
for ff = 1:length(slicesVec)

	figure 
    clim_min = min(min(XX(:,:,slicesVec(ff))));
    clim_max = max(max(XX(:,:,slicesVec(ff))));
	subplot(1,3,1)
	imagesc(real(XX(:,:,slicesVec(ff))))
	xlabel(sprintf('Slice %d', slicesVec(ff)))
	%lims = clim;
    caxis([clim_min clim_max])
    colorbar
	subplot(1,3,2)
	imagesc(real(X1Matrix(:,:,slicesVec(ff))))
	xlabel('Slice-wise Matrix Recovery')
    caxis([clim_min clim_max])
	subplot(1,3,3)
	%clim(lims)
	imagesc(real(X1Tensor(:,:,slicesVec(ff))))
	xlabel('Tensor Recovery')
	%clim(lims)
    caxis([clim_min clim_max])
	colorbar



	if(saveBoo)
	    set(gcf,'WindowStyle','normal'); 
	    set(gcf,'PaperPositionMode','Auto');
	    set(gcf, 'PaperUnits', 'inches');
	    set(gcf, 'PaperPosition', [0 0 18 5]); 
	    fname = sprintf('%s_%drr_%dframe_final', mfilename(pwd), rr, slicesVec(ff));
	    savefig(strcat(fname ,'.fig'))
	    saveas(gcf, strcat(fname ,'.png'))
    end


    figure 
    diffMatrix = abs(real(X1Matrix(:,:,slicesVec(ff))) - real(XX(:,:,slicesVec(ff))));
    diffTensor = abs(real(X1Tensor(:,:,slicesVec(ff)) - real(XX(:,:,slicesVec(ff)))));
    clim_min = min( min(diffMatrix(:)), min(diffTensor(:)));
    clim_max = max( max(diffMatrix(:)), max(diffTensor(:)));
	subplot(1,3,1)
	imagesc(zeros(n1,n2))
    caxis([clim_min clim_max])
    colorbar
	subplot(1,3,2)
	imagesc(diffMatrix)
	xlabel('Slice-wise Matrix Recovery')
    caxis([clim_min clim_max])
	subplot(1,3,3)
	%clim(lims)
	imagesc(diffTensor)
	xlabel('Tensor Recovery')
	%clim(lims)
    caxis([clim_min clim_max])

    if(saveBoo)
	    set(gcf,'WindowStyle','normal'); 
	    set(gcf,'PaperPositionMode','Auto');
	    set(gcf, 'PaperUnits', 'inches');
	    set(gcf, 'PaperPosition', [0 0 18 5]); 
	    fname = sprintf('%s_%drr_%dframe_diff_final', mfilename(pwd), rr, slicesVec(ff));
	    savefig(strcat(fname ,'.fig'))
	    saveas(gcf, strcat(fname ,'.png'))
    end

end










