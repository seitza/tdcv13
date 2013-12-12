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
        
        function res = HaarFeaturesCompute(obj,image,scale)
            image = padarray(image,[1,1]);
            
            % image is integral image
            scores = [];
            for i = 1:size(obj.featuresType,2)
                score = 0;
                r = round(obj.featuresPosition(1,i)*scale);
                c = round(obj.featuresPosition(2,i)*scale);
                w = round(obj.featuresPosition(3,i)*scale);
                h = round(obj.featuresPosition(4,i)*scale);

                if obj.featuresType(1,i) == 1
                    r1 = image(r+h-1+1,c+round(w/2)-1+1) -image(r+h-1+1,c)         -image(r,c+round(w/2)-1+1)      +image(r,c);
                    r2 = image(r+h-1+1,c+w-1+1)     -image(r+h-1+1,c+round(w/2))   -image(r,c+w-1+1)          +image(r,c+round(w/2));
                    score = r1 + r2;
                elseif obj.featuresType(1,i) == 2
                    r1 = image(r+round(h/2)-1+1,c+w-1+1) -image(r,c+w-1+1)         -image(r+round(h/2)-1+1,c)     +image(r,c);
                    r2 = image(r+h-1+1,c+w-1+1)     -image(r+round(h/2)+1,c+w-1)   -image(r+h-1+1,c)         +image(r+round(h/2),c);
                    score = r1 + r2;  
                elseif obj.featuresType(1,i) == 3
                    r1 = image(r+(h)-1+1,c+round(w/3)-1+1)   -image(r,c+round(w/3)-1+1)     -image(r+(h)-1+1,c)           +image(r,c);
                    r2 = image(r+(h)-1+1,c+round(2*w/3)-1+1) -image(r,c+round(2*w/3)-1+1)   -image(r+(h)-1+1,c+round(w/3))     +image(r,c+round(w/3));
                    r3 = image(r+h-1+1,c+w-1+1)         -image(r,c+w-1+1)        -image(r+h-1+1,c+round(2*w/3))      +image(r,c+round(2*w/3));
                    score = r1 - r2 + r3;
                elseif obj.featuresType(1,i) == 4
                    r1 = image(r+round(h/3)-1+1,c+w-1+1)     -image(r,c+w-1+1)         -image(r+round(h/3)-1+1,c)         +image(r,c);
                    r2 = image(r+round(2*h/3)-1+1,c+w-1+1)   -image(r+round(2*h/3)-1+1,c)   -image(r+round(h/3),c+w-1+1)       +image(r+round(h/3),c);
                    r3 = image(r+h-1+1,c+w-1+1)         -image(r+h-1+1,c)         -image(r+round(2*h/3),c+w-1+1)     +image(r+round(2*h/3),c);
                    score = r1 - r2 + r3;
                elseif obj.featuresType(1,i) == 5
                    r1 = image(r+round(h/2)-1+1,c+round(w/2)-1+1) -image(r,c+round(w/2)-1+1)         -image(r+round(h/2)-1+1,c)         +image(r,c);
                    r2 = image(r+round(h/2)-1+1,c+w-1+1)     -image(r,c+w-1+1)             -image(r+round(h/2)-1+1,c+round(w/2))   +image(r,c+round(w/2));
                    r3 = image(r+h-1+1,c+round(w/2)-1+1)     -image(r+round(h/2),c+round(w/2)-1+1)   -image(r+h-1+1,c)             +image(r+round(h/2),c);
                    r4 = image(r+h-1+1,c+w-1+1)         -image(r+round(h/2),c+w-1+1)       -image(r+h-1+1,c+round(w/2))       +image(r+round(h/2),c+round(w/2));
                    score = r1 - r2 + r3 - r4;
                end
                scores = [scores,score];
                
            end
            lower = obj.featuresAttributes(1,:)-abs(obj.featuresAttributes(1,:) - obj.featuresAttributes(4,:)).*(obj.featuresAttributes(5,:)-5)/50;
            upper = obj.featuresAttributes(1,:)+abs(obj.featuresAttributes(3,:) - obj.featuresAttributes(1,:)).*(obj.featuresAttributes(5,:)-5)/50;
            
            alpha = obj.featuresAttributes(6,:);
            %scores = scores .* alpha;
            res = (lower <= scores) & (scores <= upper);
            %disp(res);
            %disp([sum(res) size(alpha,2)])
            %res = (res-0.5)*2;
            %res = sum(res.*alpha);
            res = sum(res);
        end
        
    end
    
end

