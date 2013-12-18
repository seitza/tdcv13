function [ e ] = energy( A, RT, M, m )
%ENERGY Summary of this function goes here
%   Detailed explanation goes here

    ra = RT(1); rb = RT(2); rc = RT(3);
    t1 = RT(4); t2 = RT(5); t3 = RT(6);   

    Ra =  [cos(ra) -sin(ra) 0;
            sin(ra) cos(ra) 0;
            0 0 1;
        ];
    Rb =  [cos(rb) 0 -sin(rb);
            0 1 0;
            sin(rb) 0 cos(rb);
        ];
    Rc =  [1 0 0 
           0 cos(rc) -sin(rc);
           0 sin(rc) cos(rc);
        ];
    

    
    R = Ra*Rb*Rc;
    T = [t1;t2;t3];
    RT = [R,T];

    e = sum(norm(A*RT*M));

end


