classdef AdaboostClassifier < handle
    %ADABOOSTCLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        weakClassifier
        alpha
    end
    
    methods
        function obj=AdaboostClassifier(numberWeakClassifiers)
            obj.weakClassifier = cell(numberWeakClassifiers,1);
            for i = 1:numberWeakClassifiers
                obj.weakClassifier{i} = WeakClassifier();
            end
            obj.alpha = zeros(numberWeakClassifiers,1);
        end %constructor
        
        function train(obj,trainingExamples,labels)
            %number of training examples
            N = size(trainingExamples,1);
            %number of classifiers
            M = size(obj.weakClassifier,1);
            
            % initialize weighting coefficients w
            w_init = ones(N,1)/N;
            w_iter = w_init;
            for m = 1:M
                obj.weakClassifier{m}.train(trainingExamples,labels,w_iter);
                
                right_dim = trainingExamples(:,obj.weakClassifier{m}.dimensionThreshold);
                right_dim_lower = right_dim < obj.weakClassifier{m}.threshold;
                right_dim_higher = right_dim >= obj.weakClassifier{m}.threshold;
                
                e = (sum((labels(right_dim_lower)~=-1).*w_iter(right_dim_lower))+sum((labels(right_dim_higher)~=1).*w_iter(right_dim_higher)))/sum(w_iter);
                
                obj.alpha(m) = log((1-e)/e);
            
                w_iter = w_iter.*exp(obj.alpha(m).*(labels~=((right_dim_lower.*-2)+1)));
                
            end
            
        end % train
        
        function res=test(obj, testSamples)
            class = zeros(size(testSamples,1),1);
            for i = 1:size(obj.weakClassifier,1)
               class = class+(obj.alpha(i).*obj.weakClassifier{i}.test(testSamples)); 
            end
            res = sign(class); 
        end % test
        
        function dispClassifiers(obj)
            disp('ada classifiers')
            for i = 1:size(obj.weakClassifier,1)
                disp([obj.weakClassifier{i}.dimensionThreshold,obj.weakClassifier{i}.threshold]);
            end
        end
    end
    
end

