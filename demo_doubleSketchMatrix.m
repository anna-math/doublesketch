close all
clc
clear

addpath('utils/')

r0 = 10; 
n1 = 100;
n2 = 100;

r1 = 11;
eps1 = 0.01;
eps2 = 0.01;

% Original Signal
X0 = randn(n1,r0) * randn(r0,n2);

% Noisy Sketch
[YY, Ytilde, SS] = dsSketch(X0, r1, eps1, eps2);

% Recover
X1 = dsRecovery(YY, Ytilde, SS);

% Measure Error
err = norm(X1 - X0,'fro')/norm(X0, 'fro')




