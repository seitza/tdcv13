function [ f ] = energy_function( A, rt, M, m )

    ra = rt(1);
    rb = rt(2);
    rg = rt(3);
    t1 = rt(4);
    t2 = rt(5);
    t3 = rt(6);

    R = rotation_matrix(ra, rb, rg);
    T = [t1;t2;t3];
    RT = [R,T];
    
    f = sum(sum((A*RT*M-m).^2));
    
%     syms e(A, RT, M, m);
%     e(A, RT, M, m) = sum(sqrt(sum((A*RT*M-m).^2)));
%     J = [];

end

