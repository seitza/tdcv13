classdef Ferns

    
    properties
        hist
        sample
    end
        
    
    methods
        function ferns(nb_ferns, depth, nb_classes)
            F.hist = zeros(nb_ferns,2^depth, nb_classes);
            F.sample = randi(nb_ferns,depth,2);
        end
        
        function saveFern(F,filename)
            save(filename,'F');            
        end
        
        function F = loadFern(filename)
            F = load(filename);
        end 
        

           
%         function train (F,classe,patch)
%             for i=1:size(F.sample,1);
%                 for j=1:size(patch);
%                     for k=1:size(F.sample,3)
%                         if  < 
%                             binary_path(feat) = 1;
%                         end
%                     end
%                 
%                 end
%             end    
%         end 
        
        function normalize(F)
            % for all ferns normalize hist
            for f=1:size(F.sample,1)
                norm = sum(F.hist(f,:,:));
                for h=1:size(F.hist,3)
                    F.hist(f,:,h) = F.hist(f,:,h)./norm(h);
                end
            end
        end
        
%         
%         function classify ()
%            
%         end 
%         
    end
    
end

