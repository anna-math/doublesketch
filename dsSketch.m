function [YY, Ytilde, SS] = dsSketch(X0, r1, eps1, eps2)
% double sketch with T-Prod Measurements

% Inputs
%	    X0: Matrix to be sketches
%	    rr: rank to sketch
%		eps1: norm error for sketch 1
%		eps2: norm error for sketch 2
%		
% Outputs
%       YY: Sketch 1 of the double sketch YY = SX0 + Z
%       Ytilde: Sketch 2 of the doucle sketch Ytilde = X0'Stilde + Ztilde
%       SS: Sketch matrix S from YY sketch


%% Parameters
[n1,n2,n3] = size(X0);

SS = cat(3, randn(r1,n1,1), zeros(r1,n1,n3-1));
St = cat(3, randn(r1,n2,1), zeros(r1,n2,n3-1));


%SS = randn(r1,n1,n3);
%St = randn(r1,n2,n3);

Z1 = randn(r1,n2,n3);
Z1 = Z1 ./ tnorm(Z1) * eps1;
Z2 = randn(r1,n1,n3);
Z2 = Z2 ./ tnorm(Z2) * eps2;


YY = tprod(SS,X0) + Z1;
Ytilde = tprod(St,tran(X0)) + Z2;

end



