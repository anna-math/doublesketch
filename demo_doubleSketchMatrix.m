close all
clc
clear

r0 = 10; 
n1 = 100;
n2 = 100;

r1 = 11;
eps1 = 0.01;
eps2 = 0.01;

% Original Signal
X0 = randn(n1,r0) * randn(r0,n2);

% Noisy Sketch
Z1 = randn(r1,n2);
Z1 = Z1 ./ tnorm(Z1) * eps1;
Z2 = randn(r1,n1);
Z2 = Z2 ./ tnorm(Z2) * eps2;
[YY, Ytilde, SS] = dsSketch(X0, r1, Z1, Z2);

% Recover
X1 = dsRecovery(YY, Ytilde, SS);

% Measure Error
err = norm(X1 - X0,'fro')/norm(X0, 'fro')




