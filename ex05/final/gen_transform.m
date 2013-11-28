function [ H ] = gen_transform( theta, phi, lambda1, lambda2)
%iteriert für theta [0:360], phi [0:180]
%lambda frisst speicher ohne ende daher beschränkung auf lambda \in [1:10]

R_theta = [[cosd(theta),-sind(theta)];[sind(theta),cosd(theta)]];
R_phi = [[cosd(phi),-sind(phi)];[sind(phi),cosd(phi)]];
R_mphi = [[cosd(-phi),-sind(-phi)];[sind(-phi),cosd(-phi)]];
D = [[lambda1, 0];[0, lambda2]];
A = R_theta*R_mphi*D*R_phi;
H = [[A,[0;0]];[0,0,1]];

end

