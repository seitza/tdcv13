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
            n = size(training_set,1);
            obj.weights = ones(n,1) / n;
            
            for i=1:obj.number_weak_classifiers
                cur_classifier = obj.weak_classifiers(i);
                % train classifier
                weighted_error = cur_classifier.train(training_set, ...
                                                               training_labels, ...
                                                               obj.weights);
                
                % classify dataset
                predicted_classification = ((training_set(:,cur_classifier.dimension_threshold) <= cur_classifier.threshold)*2)-1;
                
                eps_i = weighted_error/ sum(obj.weights);
                obj.alphas(i) = log((1 - eps_i) / eps_i);
                
                % update weights for next training step
                obj.weights = obj.weights .* exp(obj.alphas(i) .* (training_labels ~= predicted_classification));
            end
        end
        
        function [test_labels] = test(obj, test_set)
            test_labels = zeros(size(test_set,1),1);
            for i = 1:obj.number_weak_classifiers
                test_labels = test_labels + obj.alphas(i) * obj.weak_classifiers(i).test(test_set);
            end
            test_labels = sign(test_labels);
        end
    end
end