function [ R ] = rotation( ra, rb, rc )
%ROTATION Summary of this function goes here
%   Detailed explanation goes here
%Euler
    Ra = [cos(ra), -sin(ra), 0; sin(ra), cos(ra), 0; 0,0,1];
    Rb = [cos(rb), 0, sin(rb); 0,1,0; -sin(rb), 0, cos(rb)];
    Rc = [1,0,0; 0, cos(rc), -sin(rc); 0, sin(rc), cos(rc)];
    
    R = Ra*Rb*Rc;

end

