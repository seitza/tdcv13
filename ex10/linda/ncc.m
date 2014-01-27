function [ score ] = ncc( x,y,I,T )
% I --> Image
% T --> Template

    [k,l] = size(T);

    I_rect = I(y:y+k-1, x:x+l-1);
    
    e = sum(sum(T .* I_rect));
    n = sqrt(sum(sum(T.^2))) * sqrt(sum(sum(I_rect.^2)));
    score = e/n;

end

