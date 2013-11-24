% function to create the affine transformation matrix
% the parameters are:
% - theta - one rotation
% - phi - the other rotation
% - lambdas (the scaling)
function H = create_affine_transform(theta, phi, lambdas, translation)
    R_theta = [cos(theta) -sin(theta);
               sin(theta) cos(theta)];
           
    R_phi = [cos(phi) -sin(phi);
             sin(phi) cos(phi)];
         
    R_minus_phi = [cos(-phi) -sin(-phi);
                   sin(-phi) cos(-phi)];
               
    D = [lambdas(1) 0;
         0 lambdas(2)];
     
    A = R_theta*R_minus_phi*D*R_phi;
    H = horzcat(A, translation);
    H = vertcat(H,zeros(1,3));
    H(3,3) = 1;
    H = H';
end
