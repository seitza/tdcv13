classdef AdaboostClassifier < handle
    %ADABOOSTCLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        weakClassifier  % 1xM
        alpha           % 1xM
    end
    
    methods (Access = public)
        % constructor
        function obj = AdaboostClassifier(numberWeakClassifier)
            for i = numberWeakClassifier :-1:1
                a(i) = WeakClassifier();
            end
            obj.weakClassifier = a;
            obj.alpha = zeros(1,numberWeakClassifier);
        end
        
        % training
        function obj = train(obj, trainingExamples, labels)
            N = size(trainingExamples, 1);      % number of samples
            M = size(obj.weakClassifier, 2);    % number of classifier to be trained

            importanceWeight = ones(N, 1);
            importanceWeight = importanceWeight./N;
            
            for m = 1:M
                % create classifier
                disp([num2str(m) '. Classifier #####################################################']);
                obj.weakClassifier(m).train(trainingExamples, labels, importanceWeight);
                
                % determine epsilon
                epsilon = 0;
                for sample = 1:N
                    if ((trainingExamples(sample, obj.weakClassifier(m).dimensionThreshold) <= obj.weakClassifier(m).threshold && labels(sample) ~= -1) || (trainingExamples(sample, obj.weakClassifier(m).dimensionThreshold) > obj.weakClassifier(m).threshold && labels(sample) ~= 1))
                        epsilon = epsilon + importanceWeight(sample);
                    end
                end
                epsilon = epsilon / sum(importanceWeight);

                % determine alpha
                obj.alpha(m) = log((1-epsilon)/epsilon);
                
                % update importanceWeights
                for n = 1:N
                    I = (trainingExamples(n, obj.weakClassifier(m).dimensionThreshold) <= obj.weakClassifier(m).threshold && labels(n) ~= -1) || (trainingExamples(n, obj.weakClassifier(m).dimensionThreshold) > obj.weakClassifier(m).threshold && labels(n) ~= 1);
                    %disp(I);
                    importanceWeight(n) = importanceWeight(n)*exp(obj.alpha(m)*I);
                end
                
            end
            
        end
        
        % testing
        function labels = test(obj, testingExamples)
            sums = zeros(size(testingExamples,1), 1);   %Nx1
            for m = 1:size(obj.weakClassifier, 2)
                y = obj.weakClassifier(m).test(testingExamples);
                sums = sums + (obj.alpha(m) .* y);
            end
            labels = sign(sums);
        end
    end
    
end

