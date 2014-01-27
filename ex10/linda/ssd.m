function [ score ] = ssd( x, y, I, T )
% I --> Image
% T --> Template
    [k,l, z] = size(T);
    score = sum(sum((T - I(y:y+k-1, x:x+l-1)).^2))/numel(T);

end

