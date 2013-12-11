classdef AdaboostClassifier
    %ADABOOSTCLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        weakClassifier
        alpha
    end
    
    methods
        
        % Constructor
         function obj = AdaboostClassifier(numberWeakClassifiers)
            for i=1:numberWeakClassifiers
                a(i) = WeakClassifier();
            end
            obj.weakClassifier = a;
            obj.alpha = zeros(numberWeakClassifiers,1);
         end
    
        % Train
         function train(obj,trainingExamples,labels)
            sizeExamples = size(trainingExamples,1);               
            weights = ones(sizeExamples,1)/sizeExamples;
            
            for i = 1:size(obj.weakClassifier,2)
                
                
                obj.alpha(i) = obj.weakClassifier(i).train(trainingExamples, labels, weights);
                % update weights
                if obj.weakClassifier(i).direction == 1
                    b = trainingExamples(:, obj.weakClassifier(i).dimensionThreshold) <= obj.weakClassifier(i).threshold;
                else
                    b = trainingExamples(:, obj.weakClassifier(i).dimensionThreshold) > obj.weakClassifier(i).threshold;
                end
                I = (b==1 & labels ~= -1) | (b == 0 & labels ~= 1);
                
                
%                 classifierTmp = obj.weakClassifier(i);
%                 weightedError = classifierTmp.train(trainingExamples,labels,weights);
%                 classifier = ((trainingExamples(:,obj.classifierTmp.dimensionThreshold) <= classifierTmp.threshold)*2)-1;
%               
%                 epsilon = weightedError/sum(weights);
%                 obj.alpha(i) = log((1-epsilon)/epsilon);
                
                 weights = weights.*exp((obj.alpha(i).* (2.*I))-1); 
                 weights  = weights ./ sum(weights);
            end           
         end 
        
         
         % Test
          function result = test(obj, testingExamples)
            c = zeros(size(testingExamples,1),1);
            for i = 1:size(obj.weakClassifier,2)
               c = c+(obj.alpha(i).*obj.weakClassifier(i).test(testingExamples));
            end
            result = sign(c);
          end 
          
    end

    
end

