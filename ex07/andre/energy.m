function [ e ] = energy( A, RT, M, m )
    %A intrinsic camera matrix 3x3
    %M homogenous 3D coordinates 4xn
    %m homogenous 2D coordinates 3xn
    %RT vector containing ra, rb, rc, t1,t2,t3

    %extract rotation and translation
    ra = RT(1); rb = RT(2); rc = RT(3);
    t1 = RT(4); t2 = RT(5); t3 = RT(6);
    
    R = rotation(ra,rb,rc);
    T = [t1;t2;t3];
    RT = [R,T];
    
    t = (A * RT * M) - m;
    e = sum(sqrt(sum(t.^2,1)));

end

