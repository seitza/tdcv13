classdef ferns < handle
    properties
        % suggested in exercise sheet
        depth_of_fern = 10;
        number_of_ferns = 20;
        patch_size = [30; 30];
        single_ferns = [];
        nr_of_classes = 400;
    end
    
    methods
        function obj = ferns(number_of_ferns, depth_of_fern, patch_size, nr_of_classes)
            % else use default parameters
            if nargin > 0
                obj.depth_of_fern = depth_of_fern;
                obj.number_of_ferns = number_of_ferns;
                obj.patch_size = patch_size;
                obj.nr_of_classes = nr_of_classes;
            end
            init(obj);
        end
        
        % inits all ferns
        function init(obj)
            for i=1:obj.number_of_ferns
                obj.single_ferns = [obj.single_ferns, fern(obj.depth_of_fern, obj.patch_size, obj.nr_of_classes)];
            end
        end
        
        function train(obj, patches, class_labels)
            for i=1:obj.number_of_ferns
                obj.single_ferns(i).train_patches(patches, class_labels);
            end
        end
        
        function class = classify(obj, patch)
            % multiply the posterior probabilities
            % of every fern
            posterior_probabilities = ones(1, obj.nr_of_classes);
            for i=1:obj.number_of_ferns
                posterior_probabilities(1,:) = posterior_probabilities.*obj.single_ferns(i).classify_patch(patch);
            end
            % now calculate the maximum
            [~,class] = max(posterior_probabilities);
        end
        
        % normalize the ferns before using them!
        function normalize(obj)
            for i=1:obj.number_of_ferns
                obj.single_ferns(i).normalize();
            end
        end
        
        function save_obj = saveobj(obj)
        end
    end
    
end

