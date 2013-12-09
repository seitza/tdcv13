classdef WeakClassifier < handle
    %WEAKCLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dimensionThreshold
        threshold
        direction
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
            %for d = 1:dimensions
            d = randi(dimensions,1)
            cutPoints = unique(trainingExamples(:,d));
            %N = size(cutPoints,2)
                %[Y,I] = sort(trainingExamples(:,d));
                %sortedLabels = labels(I,1);
                sortedLabels=labels;
                %sortedWeights = importanceWeights(I,1);
                sortedWeights = importanceWeights;
                
                label=(repmat(trainingExamples(:,d),1,size(cutPoints,1))<repmat(cutPoints',size(trainingExamples(:,d),1),1))*2-1;
                label_inv=(repmat(trainingExamples(:,d),1,size(cutPoints,1))>=repmat(cutPoints',size(trainingExamples(:,d),1),1))*2-1;

                err=sum((label==repmat(labels,1,size(cutPoints,1))).*repmat(importanceWeights,1,size(cutPoints,1)),1);
                [miner,pos]=min(err);
                err=sum((label_inv==repmat(labels,1,size(cutPoints,1))).*repmat(importanceWeights,1,size(cutPoints,1)),1);
                [miner2,pos]=min(err);
                if(miner2<miner)
                    obj.direction=-1;
                else
                    obj.direction=1;
                end
                
                obj.dimensionThreshold=d;
                obj.threshold=cutPoints(pos);
                
                %                 for n = 1:N-1
%                     J = sum([(sortedLabels(1:n,1)~=-1).*sortedWeights(1:n,1);(sortedLabels(n+1:N,1)~=1).*sortedWeights(n+1:N,1)]);
%                     if J < minError
%                        minError = J;
%                        obj.dimensionThreshold = d;
%                        obj.threshold = trainingExamples(I(n),d);
%                     end
%                 end %thresholds
%             %end %dimensions
      
        end % training
        
        function res=test(obj, testSamples)
            if(obj.direction==1)
                res = ((testSamples(:,obj.dimensionThreshold)<obj.threshold)-0.5)*-2;
            else
                res = ((testSamples(:,obj.dimensionThreshold)>obj.threshold)-0.5)*-2;
            end
        end % testing
    end
    
end

