classdef AdaboostClassifier
    properties
        weak_classifiers;
        alphas;
    end
    
    methods
        function obj = AdaboostClassifier(number_weak_classifiers)
            obj.weak_classifiers = weakClassifier.empty(0,number_weak_classifiers);
            for i=1:number_weak_classifiers
                obj.weak_classifiers(i) = weakClassifier();
            end
        end
    end
end