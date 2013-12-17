function [ R ] = rotation_matrix( ra, rb, rg )
    % create R using the Euler representation

    Ra = [cos(ra), -sin(ra), 0; sin(ra), cos(ra), 0; 0,0,1];
    Rb = [cos(rb), 0, sin(rb); 0,1,0; -sin(rb), 0, cos(rb)];
    Rg = [1,0,0; 0, cos(rg), -sin(rg); 0, sin(rg), cos(rg)];
    
    R = Ra*Rb*Rg;

end

