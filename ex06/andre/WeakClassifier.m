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
        
        function train(obj, dat, lbl, w)
            %dat: array numberxdimension
            %lbl: arrays nx1
            %w: nx1
            
            tmpE = intmax;
            tmpDir = 0;
            tmpDim = 0;
            tmpThres = 0;
            
            dimensions = size(dat,2);
            for d = 1:dimensions
                cutP = unique(dat(:,d));
                
                label=(repmat(dat(:,d),1,size(cutP,1))<repmat(cutP',size(dat(:,d),1),1))*2-1;
                label_inv=(repmat(dat(:,d),1,size(cutP,1))>=repmat(cutP',size(dat(:,d),1),1))*2-1;

                err=sum((label==repmat(lbl,1,size(cutP,1))).*repmat(w,1,size(cutP,1)),1);
                [minE1,pos1]=min(err);
                err=sum((label_inv==repmat(lbl,1,size(cutP,1))).*repmat(w,1,size(cutP,1)),1);
                [minE2,pos2]=min(err);
                if(minE2<minE1)
                    if(minE2<tmpE)
                        tmpE = minE2;
                        tmpDir=-1;
                        tmpDim=d;
                        tmpThres=cutP(pos2);
                    end
                else
                    if(minE1<tmpE)
                        tmpE = minE1;
                        tmpDir=1;
                        tmpDim=d;
                        tmpThres=cutP(pos1);
                    end
                end
            end %dimensions
            
            obj.direction=tmpDir;
            obj.dimensionThreshold=tmpDim;
            obj.threshold=tmpThres;
        end % training
        
        function res=test(obj, testSamples)
            if(obj.direction==1)
                res = ((testSamples(:,obj.dimensionThreshold)<obj.threshold)-0.5)*-2;
            else
                res = ((testSamples(:,obj.dimensionThreshold)>=obj.threshold)-0.5)*-2;
            end
        end % testing
    end
    
end

