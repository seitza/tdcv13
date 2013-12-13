function [ f ] = energy_function( A, ralpha, rbeta, rgamma, t1, t2, t3, M, m )

    % create R using the Euler representation
    Ralpha = [cos(ralpha), -sin(ralpha), 0; sin(ralpha), cos(ralpha), 0; 0,0,1];
    Rbeta = [cos(rbeta), 0, sin(rbeta); 0,1,0; -sin(rbeta), 0, cos(rbeta)];
    Rgamma = [1,0,0; 0, cos(rgamma), -sin(rgamma); 0, sin(rgamma), cos(rgamma)];
    
    R = Ralpha*Rbeta*Rgamma;
    
    


end

