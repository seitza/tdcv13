classdef ferns_simple < handle
    
    properties
        classifier
        samples
    end %properties
    
    methods
        function F = ferns_simple(number, depth, classes)
            F.classifier = zeros(number,2^depth,classes);
            F.samples = rand(number,depth,2);
        end %constructor
        
        function train_one(F,class,patch)
            for n = 1:size(F.classifier,1)
                dep = 0;
                for d = 1:size(F.samples,2)
                    p1 = patch(round(F.samples(n,d,1)*(numel(patch)-1))+1);
                    p2 = patch(round(F.samples(n,d,2)*(numel(patch)-1))+1);
                    if p1 <= p2
                        dep = dep+2^(d-1);
                    end
                end
                F.classifier(n,dep+1,class) = F.classifier(n,dep+1,class)+1;
            end
        end %train one
        
        function train_many(F,classes,patches)
            for c=classes
               F.train_one(c,patches(c,:,:)); 
            end
        end %train many
        
        function saveFile(F,filename)
            save(filename,'F');
        end %save
        
    end %methods
    
    methods(Static)
        function F = loadFile(filename)
            F = load(filename);
        end %load
    end %static methods
    
end %classdef

