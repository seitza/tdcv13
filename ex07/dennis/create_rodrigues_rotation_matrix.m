function [R] = create_rodrigues_rotation_matrix(r,theta)
    r_x = r(1);
    r_y = r(2);
    r_z = r(3);
    
    R = cos(theta)*eye(3,3) + ... 
        (1-cos(theta))*(r*r') + ...
        sin(theta)*[0 -r_z r_y;
                    r_z 0 -r_x;
                    r_y r_x 0];
end