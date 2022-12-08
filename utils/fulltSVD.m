function [U,S,V] = fulltSVD(A)
[m,p,n]=size(A);

A = fft(A,[],3);  % U=zeros(m,m,n); S = zeros(m,p,n); V = zeros(p,p,n);



for i=1:n
    [uu,ss,vv]=svd(A(:,:,i));
    
    U(:,:,i) = uu; S(:,:,i)=ss; V(:,:,i)=vv;   SD(:,i) = ss(:);  %SD should have k rows
end
keyboard
U = ifft(U,[],3); S = ifft(S,[],3); V = ifft(V,[],3);

return
end
