classdef hist
    %HIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        classes;
        counts;
    end %properties
    
    methods
        function H = hist(classes_in)
            if(nargin~=0)
               H.classes = classes_in;
               H.counts = zeros(1,classes_in);
            end
        end % constructor
    end %methods
    
end %hist

