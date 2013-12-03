classdef AdaboostClassifier < handle
    
    properties
        weakClassifier
        alpha
    end
    
    methods
        %constructor
        function obj = AdaboostClassifier(numberWeakClassifiers)
            obj.alpha = zeros(1,numberWeakClassifiers);
            for i = numberWeakClassifiers :-1:1
                a(i) = WeakClassifier();
            end
            obj.weakClassifier = a;
        end
        
        function  train(obj, trainingExamples, labels)
            N = size(trainingExamples, 1);  % number samples
            M = size(obj.weakClassifier, 2);   % number weak classifier
            
            importanceWeights = ones(N,1)./N;
            
            for m = 1:M
                obj.alpha(m) = obj.weakClassifier(m).train(trainingExamples, labels, importanceWeights);
                % update weights
                if (obj.weakClassifier(m).dimensionThreshold == 1)
                    b = trainingExamples(:, obj.weakClassifier(m).dimensionThreshold) <= obj.weakClassifier(m).threshold;
                else
                    b = trainingExamples(:, obj.weakClassifier(m).dimensionThreshold) >= obj.weakClassifier(m).threshold;
                end
                I = (b==1 & labels ~= -1) | (b == 0  & labels ~= 1);
                for n = 1:N
                    importanceWeights(n) = importanceWeights(n)*exp(obj.alpha(m)*I(n));
                end
            end
            
        end
        
        % testing
        function labels = test(obj, testExamples)
            sums = zeros(size(testExamples,1), 1);
            for m = 1:size(obj.weakClassifier,2)
                y = obj.weakClassifier(m).test(testExamples);
                sums = sums + (obj.alpha(m).*y);
            end
            labels = sign(sums);
        end
        
        function obj = dispAdaboost(obj)
            for m = 1:size(obj.weakClassifier, 2)
                obj.weakClassifier(m).display();
            end
        end
        
    end
    
end

