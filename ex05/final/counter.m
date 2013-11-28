classdef counter
    %COUNTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        value
    end
    
    methods
        function c = counter(init)
            c.value = init;
        end
        
        function c = increment(c)
           c.value = c.value+1; 
        end
    end
    
end

