classdef ferns
    %FERNS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        depth;
        number;
        classes;
        ferns_c;
    end %properties
    
    methods
        function F = ferns(depth_in, number_in, classes_in)
            F.depth = depth_in;
            F.number = number_in;
            F.classes = classes_in;
            ferns_c(number_in) = fern();
            F.ferns_c = ferns_c;
            for i = 1:number_in
                F.ferns_c(i) = fern(depth_in, classes_in);
            end %fill fern_c
        end %constructor
    end %methods
    
end %ferns

