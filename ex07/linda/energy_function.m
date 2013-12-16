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
    
    f = 0;
    for i =1:size(M,2)
        t = (A * RT * M(:,i)) - m(:, i);
        f = f + sqrt(t(1)^2 + t(2)^2 + t(3)^2);
    end

end

