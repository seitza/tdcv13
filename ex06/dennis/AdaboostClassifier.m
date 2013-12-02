classdef AdaboostClassifier < handle
    properties
        weak_classifiers;
        alphas;
        weights;
        number_weak_classifiers;
    end
    
    methods
        function obj = AdaboostClassifier(number_weak_classifiers)
            obj.number_weak_classifiers = number_weak_classifiers;
            obj.weak_classifiers = weakClassifier.empty(0,obj.number_weak_classifiers);
            for i=1:obj.number_weak_classifiers
                obj.weak_classifiers(i) = weakClassifier();
            end
        end
        
        function train(obj, training_set, training_labels)
            % first, set all weights to 1/N
            obj.weights = ones(obj.number_weak_classifiers,1) / obj.number_weak_classifiers;
            
            for i=1:obj.number_weak_classifiers
                cur_classifier = obj.weak_classifiers(i);
                
                % train classifier
                weighted_error = cur_classifier.train(training_set, ...
                                                      training_labels, ...
                                                      obj.weights);
                
                % classify dataset
                data_set = horzcat(training_set, training_labels);
                
                left_node = data_set(data_set(:,cur_classifier.dimension_threshold) <= cur_classifier.threshold,:);
                left_node = horzcat(left_node, ones(size(left_node,1),1));

                % right node - all data which is > threshold and gets
                % the class label -1
                right_node = data_set(data_set(:,cur_classifier.dimension_threshold) > cur_classifier.threshold,:);
                right_node = horzcat(right_node, -ones(size(right_node,1),1));

                % test how many points were classified correctly
                [false_classifications_left,~] = find(left_node(:,end-1) ~= left_node(:,end));
                [false_classifications_right,~] = find(right_node(:,end-1) ~= right_node(:,end));
                total_false_classifications = numel(false_classifications_left) + numel(false_classifications_right);
                
                eps_i = weighted_error/ sum(obj.weights);
                obj.alphas(i) = log((1 - eps_i) / eps_i);
                
                % update weights for next training step
                obj.weights = obj.weights * exp(obj.alphas(i) * total_false_classifications);
            end
        end
    end
end