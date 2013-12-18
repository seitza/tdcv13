function [ e ] = energy( A, ra, rb, rc, t1, t2, t3, M, m )
%ENERGY Summary of this function goes here
%   Detailed explanation goes here

    Ra =  [cos(ra) -sin(ra) 0;
            sin(ra) cos(ra) 0;
            0 0 1;
        ];
    Rb =  [cos(rb) 0 -sin(rb);
            0 1 0;
            sin(rb) 0 cor(rb);
        ];
    Rc =  [1 0 0 
           0 cos(rc) -sin(rc);
           0 sin(rc) cos(rc);
        ];
    
    R = Ra*Rb*Rc;
    T = [t1;t2;t3];
    RT = [R T];

    e = sum(norm(A*RT*M-m));

end

