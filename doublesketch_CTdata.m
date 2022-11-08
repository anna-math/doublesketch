close all
clc
clear

addpath('utils')
load CTdata.mat 

eps1 = 0.01;
eps2 =  0.01;
rr = 200;
saveBoo = true;

XX = XX ./ tnorm(XX);
[n1,n2,n3] = size(XX);

%% AS TENSOR 
	% Noisy Sketch
	[YY, Ytilde, SS] = dsSketch(XX, rr, eps1, eps2);

	% Transform
	YY = fft(YY, [], 3);
	Ytilde = fft(Ytilde, [], 3);
	SS = fft(SS, [], 3);

	% Recover
	X1Tensor = dsRecovery(YY, Ytilde, SS);
	X1Tensor = ifft(X1Tensor, [], 3);

	errTensor = tnorm(X1Tensor - XX)

%% AS MATRIX 
X1Matrix = zeros(n1,n2,n3);

% Noisy Sketch
for ii = 1:n3
	[YY, Ytilde, SS] = dsSketch(XX(:,:,ii), rr, eps1, eps2);
	Xi = dsRecovery(YY, Ytilde, SS);
	X1Matrix(:,:,ii) = Xi;
end

errMat = tnorm(X1Matrix - XX)





figure('DefaultAxesFontSize',16)
slicesVec = [20]
for ff = 1:length(slicesVec)

	figure 
	subplot(1,3,1)
	imagesc(real(XX(:,:,slicesVec(ff))))
	xlabel(sprintf('Slice %d', slicesVec(ff)))
	lims = clim;
	subplot(1,3,2)
	imagesc(real(X1Matrix(:,:,slicesVec(ff))))
	xlabel('Slice-wise Matrix Recovery')
	subplot(1,3,3)
	clim(lims)
	imagesc(real(X1Tensor(:,:,slicesVec(ff))))
	xlabel('Tensor Recovery')
	clim(lims)
	colorbar



	if(saveBoo)
	    set(gcf,'WindowStyle','normal'); 
	    set(gcf,'PaperPositionMode','Auto');
	    set(gcf, 'PaperUnits', 'inches');
	    set(gcf, 'PaperPosition', [0 0 18 5]); 
	    fname = sprintf('%s_%drr_%dframe_final', mfilename(pwd), rr, slicesVec(ff));
	    saveFigure(strcat(fname ,'.fig'))
	    saveas(gcf, strcat(fname ,'.png'))
	end


end











