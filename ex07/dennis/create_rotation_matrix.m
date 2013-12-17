function [R] = create_rotation_matrix(Angles)
    alpha = Angles(1);
    beta  = Angles(2);
    gamma = Angles(3);
    
    R = [cos(alpha), -sin(alpha), 0;
         sin(alpha), cos(alpha), 0;
         0, 0, 1] ...
         * ...
        [cos(beta), 0, sin(beta);
         0, 1, 0;
         -sin(beta), 0, cos(beta)] ...
         * ...
        [1, 0, 0;
         0, cos(gamma), -sin(gamma);
         0, sin(gamma), cos(gamma)];
end