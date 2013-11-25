classdef fern
    %FERN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        depth;
        hists;
    end %properties
    
    methods
        function F = fern(depth_in,classes_in)
            if(nargin~=0)
                F.depth = depth_in;
                hists(2^depth_in-1) = hist();
                for i = 1:2^depth_in-1
                    hists(i) = hist(classes_in);
                end % set hist sizes
                F.hists = hists;
            end % got input arguments
        end % constructor
    end %methods
    
end %classdef

