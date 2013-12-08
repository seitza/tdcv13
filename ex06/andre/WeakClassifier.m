classdef WeakClassifier < handle
    %WEAKCLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dimensionThreshold
        threshold
    end
    
    methods
        function obj=WeakClassifier()
            
        end %constructor
        
        function train(obj, trainingExamples, labels, importanceWeights)
            %training examples: array numberxdimension
            %labels: arrays nx1
            %importance weights: nx1
            
            minError = intmax;
            
            N = size(trainingExamples,1);
            dimensions = size(trainingExamples,2);
            for d = 1:dimensions
                [Y,I] = sort(trainingExamples(:,d));
                sortedLabels = labels(I,1);
                sortedWeights = importanceWeights(I,1);
                for n = 1:N-1
                    J = sum([(sortedLabels(1:n,1)~=-1).*sortedWeights(1:n,1);(sortedLabels(n+1:N,1)~=1).*sortedWeights(n+1:N,1)]);
                    if J < minError
                       minError = J;
                       obj.dimensionThreshold = d;
                       obj.threshold = trainingExamples(I(n),d);
                    end
                end %thresholds
            end %dimensions
            
        end % training
        
        function res=test(obj, testSamples)
            res = ((testSamples(:,obj.dimensionThreshold)<obj.threshold)-0.5)*-2;
        end % testing
    end
    
end

