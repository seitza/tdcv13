classdef WeakClassifier < handle

    properties
        dimensionThreshold
        threshold
    end
    
    methods
        function W = WeakClassifier()
        end
        
        function alpha = train(obj, trainingExamples, labels, importanceWeights)
            % find best thresholds
            N = size(trainingExamples, 1);  % number samples
            dim = size(trainingExamples,2);
            
            minError = intmax;
            for d = 1:dim
                for t = 1:N
                    thres = trainingExamples(t, d);
                    % compute error
                    if (d == 1)
                        b = trainingExamples(:, d) <= thres;
                    else
                        b = trainingExamples(:, d) >= thres;
                    end
                    error = sum(importanceWeights((b==1 & labels ~= -1) | (b == 0  & labels ~= 1)));
                    % update min error if necessary
                    if error < minError
                        minError = error;
                        obj.dimensionThreshold = d;
                        obj.threshold = thres;
                    end
                end
            end
            
            epsilon = minError/sum(importanceWeights);
            disp(epsilon);
            alpha = log((1-epsilon)/epsilon);
            
        end
        
        % testing
        function y = test(obj, testExamples)
            y = zeros(size(testExamples,1), 1); %Nx1
            if (obj.dimensionThreshold == 1)
                y(testExamples(:, obj.dimensionThreshold) <= obj.threshold) = -1;
                y(testExamples(:, obj.dimensionThreshold) > obj.threshold) = 1;
            else
                y(testExamples(:, obj.dimensionThreshold) >= obj.threshold) = -1;
                y(testExamples(:, obj.dimensionThreshold) < obj.threshold) = 1;
            end
        end
        
        function w = display(w)
            disp([num2str(w.dimensionThreshold) '   ' num2str(w.threshold)]);
        end
        
    end
    
end

