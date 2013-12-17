function [ f ] = energy_function( A, rt, M, m )

    ra = rt(1);
    rb = rt(2);
    rg = rt(3);
    t1 = rt(4);
    t2 = rt(5);
    t3 = rt(6);

    % create R using the Euler representation
    Ra = [cos(ra), -sin(ra), 0; sin(ra), cos(ra), 0; 0,0,1];
    Rb = [cos(rb), 0, sin(rb); 0,1,0; -sin(rb), 0, cos(rb)];
    Rg = [1,0,0; 0, cos(rg), -sin(rg); 0, sin(rg), cos(rg)];
    
    R = Ra*Rb*Rg;
    T = [t1;t2;t3];
    RT = [R,T];
    
    f = sum(sqrt(sum((A*RT*M-m).^2)));
    
%     syms e(A, RT, M, m);
%     e(A, RT, M, m) = sum(sqrt(sum((A*RT*M-m).^2)));
%     J = [];

end

