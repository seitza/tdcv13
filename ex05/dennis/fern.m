classdef fern < handle
    properties
        % default value
        depth = 20;
        patch_size = [30;30];
        
        % probabilities
        probability_table
        
        % is the fern normalized
        normalized = 0;
        nr_of_classes = 1;
        
        % the pixel location for m1-test
        m1 = [];
        % the pixel location for m2-test
        m2 = [];
    end

    % load function has to be static
   methods (Static)
        function obj = loadobj(obj)
            if isstruct(obj)
                new_obj = fern;
                new_obj.nr_of_classes = obj.nr_of_classes;
                new_obj.depth = obj.depth;
                new_obj.patch_size = obj.patch_size;
                new_obj.probability_table = obj.probability_table;
                new_obj.normalized = obj.normalized;
                new_obj.m1 = obj.m1;
                new_obj.m2 = obj.m2;
                
                obj = new_obj;
            else
                fprintf('sorry, can not parse fern object');
            end
        end
   end
    
    methods
        function obj = fern(depth, patch_size, nr_of_classes)
            if nargin > 0
                obj.depth = depth;
                obj.patch_size = patch_size;
                obj.nr_of_classes = nr_of_classes;
            end
            % create random locations for testing the image
            obj.m1 = zeros(2, obj.depth);
            % lets do it matlab style - 1 equals y values
            obj.m1(1,:) = randi(obj.patch_size(1),[1, obj.depth]);
            % x values
            obj.m1(2,:) = randi(obj.patch_size(2), [1, obj.depth]);
            
            % do the same for m2
            obj.m2 = zeros(2, obj.depth);
            % y values
            obj.m2(1,:) = randi(obj.patch_size(1),[1, obj.depth]);
            % x values
            obj.m2(2,:) = randi(obj.patch_size(2), [1, obj.depth]);
            
            % init probability table - we take the layout in the slides
            % row r equals bin r; column c equals class c.
            obj.probability_table = zeros((2^obj.depth)+1, obj.nr_of_classes);
        end
        
        % trains one patch
        function train_patch(obj, patch, class_label)
            bin_nr = get_bin(obj, patch);
            % update probability
            obj.probability_table(bin_nr, class_label) = obj.probability_table(bin_nr, class_label) + 1;
        end
        
        % train multiple patches
        function train_patches(obj, patches, class_labels)
            % patches are stacked behind each other
            % the same is done for the class labels
            for i=1:size(patches,3)
                train_patch(obj, patches(:,:,i), class_labels(i));
            end
        end
        
        % classify one patch and get back the probability
        function posterior = classify_patch(obj, patch)
            % make sure that the fern is normalized before we use 
            % it to classify a patch
            if ~obj.normalized
                fprintf('ferns is not normalized, normalization is mandatory to classify patches - force normalization...');
                normalize(obj);
            end
            bin_nr = get_bin(obj, patch);
            posterior = obj.probability_table(bin_nr, :);
        end
        
        function bin_nr = get_bin(obj, patch)
            % do all binary tests
            bin_nr = 0;
            for i=1:obj.depth
                if patch(obj.m1(1,i), obj.m1(2,i)) < patch(obj.m2(1,i), obj.m2(2,i))
                    bin_nr = 2^(i-1) + bin_nr;
                end
            end
            % do not forget to add 1 - matlab starts at 1!
            bin_nr = bin_nr + 1;
        end
        
        function normalize(obj)
           total_sum = sum(sum(obj.probability_table));
           obj.probability_table = obj.probability_table / total_sum;
        end
        
        % implement save method
        function save_obj = saveobj(obj)
            % save matrices and stuff as struct
            save_obj.nr_of_classes = obj.nr_of_classes;
            save_obj.depth = obj.depth;
            save_obj.patch_size = obj.patch_size;
            save_obj.probability_table = obj.probability_table;
            save_obj.normalized = obj.normalized;
            save_obj.m1 = obj.m1;
            save_obj.m2 = obj.m2;
        end
    end
end