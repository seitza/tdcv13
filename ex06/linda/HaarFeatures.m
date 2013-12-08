classdef HaarFeatures

    
    properties
        featurePositions;
        featureType;
        featureAttributes;
    end
    
    methods
        % constructor
        function obj = HaarFeatures(attributes)
            obj.featurePositions = attributes(1:4, :);
            obj.featureType = attributes(5, :);
            obj.featureAttributes = attributes(6:14, :);
        end
        
        % image is a patch in integral form
        function fscore = haarFeaturesCompute(obj, image)
            response = zeros(size(obj.featureType));
            pos_output = zeros(size(response));
            score = zeros(size(response));
            % iterate over all features
            for f = 1:size(obj.featureType, 2)
                r = obj.featurePositions(1,f);
                c = obj.featurePositions(2,f);
                w = obj.featurePositions(3,f);
                h = obj.featurePositions(4,f);
                % compute response depending on the feature type
                switch obj.featureType(f)
                    case 1
                        r1 = image(r+h-1, c+(w/2)-1) - image(r+h-1, c) - image(r, c+(w/2)-1) + image(r,c);
                        r2 = image(r+h-1, c+w-1) - image(r+h-1, c+(w/2)) - image(r, c+w-1) + image(r,c+(w/2));
                        response(f) = r1+r2;
                    case 2
                        r1 = image(r+(h/2)-1, c+w-1) - image(r+(h/2)-1, c) - image(r, c+w-1) + image(r,c);
                        r2 = image(r+h-1, c+w-1) - image(r+h-1, c) - image(r+h/2, c+w-1) + image(r+h/2, c);
                        response(f) = r1+r2;
                    case 3
                        r1 = image(r+h-1, c+w/3-1) - image(r+h-1,c) - image(r,c+w/3-1) + image(r,c);
                        r2 = image(r+h-1, c+2*w/3-1) - image(r+h-1, c+w/3) - image(r,c+2*w/3-1) + image(r,c+w/3);
                        r3 = image(r+h-1, c+w-1) - image(r+h-1, c+2*w/3) - image(r,c+w-1) + image(r,c+2*w/3);
                        response(f) = r1-r2+r3;
                    case 4
                        r1 = image(r+h/3-1, c+w-1) - image(r+h/3-1, c) - image(r, c+w-1) + image(r,c);
                        r2 = image(r+2*h/3-1,c+w-1) - image(r+2*h/3-1,c) - image(r+h/3, c+w-1) + image(r+h/3,c);
                        r3 = image(r+h-1, c+w-1) - image(r+h-1,c) - image(r+2*h/3, c+w-1) + image(r+2*h/3,c);
                        response(f) = r1-r2+r3;
                    case 5
                        r1 = image(r+h/2-1, c+w/2-1) - image(r+h/2-1,c) - image(r,c+w/2-1) + image(r,c);
                        r2 = image(r+h/2-1, c+w-1) - image(r+h/2-1,c+w/2) - image(r,c+w-1) + image(r,c+w/2);
                        r3 = image(r+h-1,c+w/2-1) - image(r+h-1,c) - image(r+h/2,c+w/2-1) + image(r+h/2,c);
                        r4 = image(r+h-1,c+w-1) - image(r+h-1,c+w/2) - image(r+h/2,c+w-1) + image(r+h/2,c+w/2);
                        response(f) = r1-r2+r3-r4;
                end
                % apply threshold
                mean = obj.featureAttributes(1,f);
                minPos = obj.featureAttributes(4,f);
                maxPos = obj.featureAttributes(3,f);
                R = obj.featureAttributes(5,f);
                tmin = mean-abs(mean-minPos)*(R-5)/50;
                tmax = mean+abs(maxPos-mean)*(R-5)/50;
                pos_output(f) = response(f) > tmin && response(f) < tmax;
                % multiply the 1 or 0 with alpha
                score(f) = obj.featureAttributes(6,f)*pos_output(f);
            end
            % compute final score
            fscore = sum(score);
        end
    end
    
end

