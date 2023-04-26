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
Z1 = randn(r1,n2,n3);
Z1 = Z1 ./ tnorm(Z1) * eps1;
Z2 = randn(r1,n1,n3);
Z2 = Z2 ./ tnorm(Z2) * eps2;
[YY, Ytilde, SS] = dsSketch(X0, r1, Z1, Z2);

% Transform
YYhat = fft(YY, [], 3);
Ytildehat = fft(Ytilde, [], 3);
SShat = fft(SS, [], 3);

% Recover
Xhat = dsRecovery(YYhat, Ytildehat, SShat);
X1 = ifft(Xhat, [], 3);

% Measure Error
err = tnorm(X1 - X0)/tnorm(X0)




