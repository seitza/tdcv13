function [ score ] = SSD( x, y, I, T )

%[txgrid, tygrid] = meshgrid(1:size(T,2), 1:size(T,1));
I = I(y:y+size(T,1)-1,x:x+size(T,2)-1);
Im = mean(I(:));
Tm = mean(T(:));
score = sum(sum(((T-Tm)-(I-Im)).^2))/numel(T)+numel(I);

end

