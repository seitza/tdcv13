function [ score ] = ssd( I, T )
% I --> Image
% T --> Template
    [n,m] = size(I);
    [k,l] = size(T);
    I = padarray(I, [k,l], 'post');
    score = zeros(size(n,m));
    for x = 1:n
        for y = 1:m
            for i = 1:k
                for j = 1:l
                    score(x,y) = score(x,y) + (T(i,j)-I(x+i, y+j))^2;
                end
            end
        end
    end
end

