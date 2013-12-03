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
            w = ones(N,1)/N;
            for m = 1:M
                obj.weakClassifier{m}.train(trainingExamples,labels,w); 
            
                c = ((trainingExamples(:,obj.weakClassifier{m}.dimensionThreshold)<obj.weakClassifier{m}.threshold)-0.5)*-2;
                e = sum(w.*(c~=labels));
                e = e/sum(w);
            
                a = log((1-e)/e);
                obj.alpha(m) = a;
                
                w = w.*exp(a.*(c~=labels));
                %w = w/sum(w);
            
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

