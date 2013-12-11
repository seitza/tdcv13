classdef WeakClassifier
    %WEAKCLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dimensionThreshold
        threshold
        direction
    end
    
    methods
        
        % Constructor
        function obj = WeakClassifier()
        end
        
        % Train
        function train(obj, trainingExamples, labels, importanceWeights)
            
            minError = intmax;
            dir= 0;
            for i=1:size(trainingExamples,2)
                for j=1:size(trainingExamples,1)
                    t = trainingExamples(j,i);
                    data1 = trainingExamples(:,i) <= t;
                    data2 = trainingExamples(:,i) > t;
                    error1 = sum(importanceWeights((data1==1 & labels ~=-1) | (data1 == 0 & labels ~= 1)));
                    error2 = sum(importanceWeights((data2==1 & labels ~=-1) | (data2 == 0 & labels ~= 1)));
                    if error1 < error2
                        dir = 1;
                        error = error1;
                    else
                        dir = 2;
                        error = error2;
                    end
                    
                    if error < minError
                        minError = error;
                        obj.dimensionThreshold = i;
                        obj.threshold = t;
                        obj.direction = dir;
                    end
                
                end
            end
            
            epsilon = minError/sum(importanceWeights); 
            alpha = 1/2*log((1-epsilon)/epsilon);
        end
        
        function result = test(obj, testExamples)
            result = zeros(size(testExamples,1), 1);
            if obj.direction == 1
                result(testExamples(:, obj.dimensionThreshold) <= obj.threshold) = -1;
                result(testExamples(:, obj.dimensionThreshold) > obj.threshold) = 1;
            else
                result(testExamples(:, obj.dimensionThreshold) > obj.threshold) = -1;
                result(testExamples(:, obj.dimensionThreshold) <= obj.threshold) = 1;
            end
        end
    end
    
end

