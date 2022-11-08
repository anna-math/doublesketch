function [Xhat] = dsRecovery(Y, Ytilde, S)
% Double Sketch Recovery

%% Inputs
%       YY: Sketch 1 of the double sketch YY = SX0 + Z
%       Ytilde: Sketch 2 of the doucle sketch Ytilde = X0'Stilde + Ztilde
%       SS: Sketch matrix S from YY sketch
%
%% Outputs
%       Xhat: approximation of X_0

    [~,n2,n3] = size(Y);
    [~,n1,~] = size(S);

    Xhat = zeros(n1,n2,n3);
    for kk = 1:n3
        Xhat(:,:,kk) = Ytilde(:,:,kk)'*pinv(S(:,:,kk)*Ytilde(:,:,kk)')*Y(:,:,kk);
    end

end