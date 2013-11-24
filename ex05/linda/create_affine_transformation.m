function [ T ] = create_affine_transformation( )
% create affine transformation matrix
           
        phi = rand*360;
        theta = rand*360;
        
        R_phi = [cosd(phi), -sind(phi); sind(phi), cosd(phi)];
        R_minus_phi = [cosd(-phi), -sind(-phi); sind(-phi), cosd(-phi)];
        R_theta = [cosd(theta), -sind(theta); sind(theta), cosd(theta)];
        
        lambda1 = rand*10;
        lambda2 = rand*10;
        
        D = [lambda1, 0; 0, lambda2];
        
        A = R_theta * R_minus_phi * D * R_phi;
        
        T = [A(1,:), 0; A(2,:), 0; 0,0,1];

end