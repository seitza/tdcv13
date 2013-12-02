classdef weakClassifier
    properties
        dimension_threshold;
        threshold;
    end
    
    methods
        function obj = weakClassifier()
            obj.dimension_threshold = randi(10,1);
        end
        % returns the error function
        function train(obj, training_data, training_labels, weights)
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
                    left_node = horzcat(data(data(:,cur_dimension) <= cur_threshold,:), ones(size(data,1),1));
                    % right node - all data which is > threshold and gets
                    % the class label -1
                    right_node = horzcat(data(data(:,cur_dimension) > cur_threshold,:), -ones(size(data,1),1));
                    
                    % test how many points were classified correctly
                    [false_classifications_left,~] = find(left_node(:,end-1) ~= left_node(:,end));
                    [false_classifications_right,~] = find(right_node(:,end-1) ~= right_node(:,end));
                    
                    % calculate weighted error function
                    J = sum(weights(false_classifications_left)) + sum(weights(false_classifications_right));
                    
                    % do we got a new min error
                    if J < min_error
                        obj.dimension_threshold = cur_dimension;
                        obj.threshold = cur_threshold;
                    end
                end
            end
        end
        
        % returns labels for test data
        function [test_labels] = test(obj, test_data)
            test_labels = zeros(1,size(test_data,1));
        end
    end
    
end

