classdef weakClassifier < handle
    properties
        dimension_threshold;
        threshold;
    end
    
    methods
        function obj = weakClassifier()
        end
        
        % returns the error function
        function [min_error] = train(obj, training_data, training_labels, weights)
            % current minimum error
            min_error = intmax;
            
            % get number of dimensions
            nr_dimensions = size(training_data,2);
            
            % make big matrix, (nx5), which consists of following entries
            % (training_data, weights, training_labels)
            data = horzcat(training_data, weights, training_labels);
            
            % check which dimension to choose
            for i=1:nr_dimensions
                cur_dimension = i;

                % now try every possible threshold
                for j=1:size(data,1)
                    cur_threshold = data(j,cur_dimension);
                    % split data
                    % left node - this equals to value <= threshold and
                    % gets the class label 1
                    left_node = data(data(:,cur_dimension) <= cur_threshold,:);
                    left_node = horzcat(left_node, ones(size(left_node,1),1));
                    
                    % right node - all data which is > threshold and gets
                    % the class label -1
                    right_node = data(data(:,cur_dimension) > cur_threshold,:);
                    right_node = horzcat(right_node, -ones(size(right_node,1),1));
                    
                    % test how many points were classified correctly
                    [false_classifications_left,~] = find(left_node(:,end-1) ~= left_node(:,end));
                    [false_classifications_right,~] = find(right_node(:,end-1) ~= right_node(:,end));
                    
                    % calculate weighted error function
                    J = sum(left_node(false_classifications_left,nr_dimensions+1)) + ...
                        sum(right_node(false_classifications_right,nr_dimensions+1));
                    
                    % do we got a new min error
                    if J < min_error
                        min_error = J;
                        obj.dimension_threshold = cur_dimension;
                        obj.threshold = cur_threshold;
                    end
                end
            end
        end
        
        % returns labels for test data
        function [test_labels] = test(obj, test_data)
            % partition data
            test_labels = ((test_data(:,obj.dimension_threshold) <= obj.threshold)*2)-1;
        end
    end
    
end

