classdef WeakClassifier < handle

    properties
        dimensionThreshold
        threshold
        direction
    end
    
    methods
        function W = WeakClassifier()
        end
        
        function alpha = train(obj, trainingExamples, labels, importanceWeights)
            % find best thresholds
            N = size(trainingExamples, 1);  % number samples
            dim = size(trainingExamples,2);
            
            minError = intmax;
            dir = 0;
            for d = 1:dim
                for t = 1:N
                    thres = trainingExamples(t, d);
                    % compute error
                    b1 = trainingExamples(:, d) <= thres;
                    b2 = trainingExamples(:, d) > thres;
                    error1 = sum(importanceWeights((b1==1 & labels ~= -1) | (b1 == 0  & labels ~= 1)));
                    error2 = sum(importanceWeights((b2==1 & labels ~= -1) | (b2 == 0  & labels ~= 1)));
                    if error1 < error2
                        dir = 1;
                        error = error1;
                    else
                        dir = 2;
                        error = error2;
                    end
                    % update min error if necessary
                    if error < minError
                        minError = error;
                        obj.dimensionThreshold = d;
                        obj.threshold = thres;
                        obj.direction = dir;
                    end
                end
            end
            
            epsilon = minError/sum(importanceWeights);
            %disp(epsilon);
            alpha = 1/2*log((1-epsilon)/epsilon);
            
        end
        
        % testing
        function y = test(obj, testExamples)
            y = zeros(size(testExamples,1), 1); %Nx1
            if obj.direction == 1
                y(testExamples(:, obj.dimensionThreshold) <= obj.threshold) = -1;
                y(testExamples(:, obj.dimensionThreshold) > obj.threshold) = 1;
            else
                y(testExamples(:, obj.dimensionThreshold) > obj.threshold) = -1;
                y(testExamples(:, obj.dimensionThreshold) <= obj.threshold) = 1;
            end
        end
        
        function w = display(w)
            disp([num2str(w.dimensionThreshold) '   ' num2str(w.threshold)]);
        end
        
    end
    
end

