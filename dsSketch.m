function [YY, Ytilde, SS] = dsSketch(X0, r1, Z1, Z2)
% double sketch with T-Prod Measurements

% Inputs
%	    X0: Matrix to be sketches
%	    rr: rank to sketch
%		Z1: Noise for sketch Y
%		Z2: Noise for sketch Ytilde
%		
% Outputs
%       YY: Sketch 1 of the double sketch YY = SX0 + Z
%       Ytilde: Sketch 2 of the doucle sketch Ytilde = X0'Stilde + Ztilde
%       SS: Sketch matrix S from YY sketch


%% Parameters
[n1,n2,n3] = size(X0);

SS = cat(3, randn(r1,n1,1), zeros(r1,n1,n3-1));
St = cat(3, randn(r1,n2,1), zeros(r1,n2,n3-1));
 
YY = tprod(SS,X0) + Z1;
Ytilde = tprod(St,tran(X0)) + Z2;
end



