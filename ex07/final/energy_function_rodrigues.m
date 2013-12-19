function [f] = energy_function_rodrigues(A,r_theta_T,M,m)
% This function takes the following parameters:
% - A: internal calibration matrix
% - R: the rotation parameters: (1) alpha, (2) beta, (3) gamma
% - T: the translation vector t1,t2,t3
% - M: the 3D-point
% - m: the 2D-point

% make homogenouse coordinates out of m
if size(m,1) ~= 3 || size(M,1) ~= 4
    fprintf('Please give me the 2D and 3D-Point correspondences in homogenous coordinates\n');
    return
end

% the first 3 parameters are the vector r = (rx, ry, rz)
r = r_theta_T(1:3);
theta = r_theta_T(4);
T = r_theta_T(5:end)';

R = create_rodrigues_rotation_matrix(r,theta);
 
RT = horzcat(R,T);
m_estimate = A*RT*M;
f = sum(sum((m_estimate - m).^2));
end