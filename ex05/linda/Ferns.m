classdef Ferns < handle
    % class that holds F ferns each comprising N randomly chosen features
    % and C different classes (keypoints)
    
    properties
        features    % 4xNxF matrix representing the randomly chosen feature
                    % pairs columnwise
        histograms  % 2^NxCxF matrix representing all 2^N histograms
                    % with C classes
    end
    
    methods (Access = public)
        % constructor
        % create empty ferns: number_ferns, depth, number_classes,
        % patch_size
        % read ferns: filename
        function F = Ferns(varargin)
            if nargin == 4
                F.features = randi(varargin{4}, [4, varargin{2}, varargin{1}]);
                F.histograms = zeros(2^varargin{2}, varargin{3}, varargin{1});
            elseif nargin == 1
                F.features, F.histograms = load(varargin{1});
            end
        end
        
        % saves the features and histograms to a mat file
        function F = save_fern(F,filename)
            save(filename, 'F.features', 'F.histograms');
        end
        
        % train the fern with patches in a matrix: patch_size x patch_size
        % x #patches
        % classes is a matrix: 1 x #patches
        function F = train(F, patches, classes)
            % run over all ferns
            for fern = 1:size(F.features,3)
                % run over all patches
                for p = 1:size(patches, 3)
                    % run over features and calculate binary_vector
                    hist_number = 1;
                    for feat = 1:size(F.features, 2)
                        if patches(F.features(1,feat,fern), F.features(2,feat,fern), p) < patches(F.features(3,feat,fern), F.features(4,feat,fern), p)
                            hist_number = hist_number+2^(feat-1);
                        end
                    end
                    % increment histogram
                    F.histograms(hist_number, classes(p), fern) = F.histograms(hist_number, classes(p), fern) + 1;
                end
            end
        end
        
        % normalize the ferns before usage
        function F = normalize(F)
            %run over all ferns and normalize each column of the histograms
            for fern = 1:size(F.features, 3)
                sums = sum(F.histograms(:,:,fern));
                for col = 1:size(F.histograms, 2)
                    F.histograms(:, col, fern) = F.histograms(:, col, fern)./sums(col);
                end
            end
        end
        
        function class = classify(F, patch)
            % search for histograms in each fern
            all_histograms = zeros(size(F.features, 3), size(F.histograms, 2));
            for fern = 1:size(F.features, 3)
                    % run over features and calculate binary_vector
                    hist_number = 1;
                    for feat = 1:size(F.features, 2)
                        if patch(F.features(1,feat,fern), F.features(2,feat,fern)) < patch(F.features(3,feat,fern), F.features(4,feat,fern))
                            hist_number = hist_number+2^(feat-1);
                        end
                    end
                    all_histograms(fern, :) = F.histograms(hist_number, :, fern);
            end
            total_histogram = prod(all_histograms);
            class = find(total_histogram == max(total_histogram));
            class = class(1);       % take the fist class if there are more than 1 maxima
        end
        
    end
    
end

