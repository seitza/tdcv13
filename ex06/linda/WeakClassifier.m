classdef WeakClassifier < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dimensionThreshold
        threshold
    end
    
    methods (Access = public)
        % constructor
        function obj = WeakClassifier()
            
        end
        
        % training
        function obj = train(obj, trainingExamples, labels, importanceWeight)
            N = size(trainingExamples, 1);
            dim = size(trainingExamples, 2);
            minError = Inf;
            % set different borders and evaluate the minimal error
            for d = 1:dim       % dimension
                for t = 1:N     % threshold
                    thres = trainingExamples(t,dim);
                    % calculate error for this threshold setting
                    error = 0;
                    for sample = 1:N
                        if ((trainingExamples(sample, dim) <= thres && labels(sample) ~= -1) || (trainingExamples(sample, dim) > thres && labels(sample) ~= 1))
                            error = error + importanceWeight(sample);
                        end
                    end
                    %disp(error);
                    if error < minError
                        obj.dimensionThreshold = d;
                        obj.threshold = thres;
                        minError = error;
                    end
                end
            end
            
            disp(['min eroor is ' num2str(minError)]);

        end
        
        % testing
        function y = test(obj, testExamples)
            y = zeros(size(testExamples,1), 1); %Nx1
            y(testExamples(:, obj.dimensionThreshold) <= obj.threshold) = -1;
            y(testExamples(:, obj.dimensionThreshold) > obj.threshold) = 1;
        end
        
    end
    
end

