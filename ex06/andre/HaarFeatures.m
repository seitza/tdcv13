classdef HaarFeatures < handle
    %HAARFEATURES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        featuresPosition
        featuresType
        featuresAttributes
    end
    
    methods
        function obj=HaarFeatures(Attributes)
            obj.featuresType = Attributes(5,:);
            obj.featuresAttributes = Attributes(6:14,:);
            obj.featuresPosition = Attributes(1:4,:);
        end
        
        function res = HaarFeaturesCompute(obj,image)
            % image is integral image
            scores = [];
            for i = 1:size(obj.featuresType,2)
                score = 0;
                r = obj.featuresPosition(1,i);
                c = obj.featuresPosition(2,i);
                w = obj.featuresPosition(3,i);
                h = obj.featuresPosition(4,i);
                if obj.featuresType(1,i) == 1
                    r1 = image(r+h-1,c+(w/2)-1) -image(r+h-1,c)         -image(r,c+(w/2)-1)      +image(r,c);
                    r2 = image(r+h-1,c+w-1)     -image(r+h-1,c+(w/2))   -image(r,c+w-1)          +image(r,c+(w/2));
                    score = r1 + r2;
                elseif obj.featuresType(1,i) == 2
                    r1 = image(r+(h/2)-1,c+w-1) -image(r,c+w-1)         -image(r+(h/2)-1,c)     +image(r,c);
                    r2 = image(r+h-1,c+w-1)     -image(r+(h/2),c+w-1)   -image(r+h-1,c)         +image(r+(h/2),c);
                    score = r1 + r2;  
                elseif obj.featuresType(1,i) == 3
                    r1 = image(r+(h)-1,c+(w/3)-1)   -image(r,c+(w/3)-1)     -image(r+(h)-1,c)           +image(r,c);
                    r2 = image(r+(h)-1,c+(2*w/3)-1) -image(r,c+(2*w/3)-1)   -image(r+(h)-1,c+(w/3))     +image(r,c+(w/3));
                    r3 = image(r+h-1,c+w-1)         -image(r,c+w-1)        -image(r+h-1,c+(2*w/3))      +image(r,c+(2*w/3));
                    score = r1 - r2 + r3;
                elseif obj.featuresType(1,i) == 4
                    r1 = image(r+(h/3)-1,c+w-1)     -image(r,c+w-1)         -image(r+(h/3)-1,c)         +image(r,c);
                    r2 = image(r+(2*h/3)-1,c+w-1)   -image(r+(2*h/3)-1,c)   -image(r+(h/3),c+w-1)       +image(r+(h/3),c);
                    r3 = image(r+h-1,c+w-1)         -image(r+h-1,c)         -image(r+(2*h/3),c+w-1)     +image(r+(2*h/3),c);
                    score = r1 - r2 + r3;
                elseif obj.featuresType(1,i) == 5
                    r1 = image(r+(h/2)-1,c+(w/2)-1) -image(r,c+(w/2)-1)         -image(r+(h/2)-1,c)         +image(r,c);
                    r2 = image(r+(h/2)-1,c+w-1)     -image(r,c+w-1)             -image(r+(h/2)-1,c+(w/2))   +image(r,c+(w/2));
                    r3 = image(r+h-1,c+(w/2)-1)     -image(r+(h/2),c+(w/2)-1)   -image(r+h-1,c)             +image(r+(h/2),c);
                    r4 = image(r+h-1,c+w-1)         -image(r+(h/2),c+w-1)       -image(r+h-1,c+(w/2))       +image(r+(h/2),c+(w/2));
                    score = r1 - r2 + r3 - r4;
                end
                scores = [scores,score];
                
            end
            lower = obj.featuresAttributes(1,:)-abs(obj.featuresAttributes(1,:) - obj.featuresAttributes(4,:)).*(obj.featuresAttributes(5,:)-5)/50;
            upper = obj.featuresAttributes(1,:)+abs(obj.featuresAttributes(3,:) - obj.featuresAttributes(1,:)).*(obj.featuresAttributes(5,:)-5)/50;
            
            alpha = obj.featuresAttributes(6,:);
            %scores = scores .* alpha;
            res = lower <= scores & scores <= upper;
            %res = (res-0.5)*2;
            res = sum(res.*alpha);
        end
        
    end
    
end

