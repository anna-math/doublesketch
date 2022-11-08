close all
clc
clear

addpath('utils')

r0 = 10; 
n1 = 100;
n2 = 100;
n3 = 10;

r1 = 11;
eps1 = 0.01;
eps2 = 0.01;

X0 = tprod(randn(n1,r0,n3), randn(r0,n2,n3));

% Sketch
[YY, Ytilde, SS] = dsSketch(X0, r1, eps1, eps2);

% Transform
YYhat = fft(YY, [], 3);
Ytildehat = fft(Ytilde, [], 3);
SShat = fft(SS, [], 3);

% Recover
Xhat = dsRecovery(YYhat, Ytildehat, SShat);
X1 = ifft(Xhat, [], 3);

% Measure Error
err = norm(X1 - X0,'fro')/norm(X0,'fro')




