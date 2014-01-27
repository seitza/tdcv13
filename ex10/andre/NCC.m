function [ score ] = NCC( x, y, I, T )
%x,y upper left point of T in I

Tm = mean(T(:));
Ts = std(T(:));
I = I(y:y+size(T,1)-1,x:x+size(T,2)-1,:);
Im = mean(I(:));
Is = mean(I(:));
score = sum(sum((T-Tm).*(I-Im)./sqrt(Ts)*sqrt(Is)))/numel(T)+numel(I);

end

