function [ I_pad ] = pad_rand( I,T )

    [k,l] = size(T);
    [n,m,o] = size(I);
    
    r = rand(n+k,l);
    u = rand(k,m);
    I_pad = [I;repmat(u, 1,1,o)];
    I_pad = [I_pad,repmat(r, 1,1,o)];

end

