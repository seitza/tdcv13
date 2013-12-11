function [ scores, I ] = classify_face( haar, I )

    I = imfilter(I, fspecial('gaussian'));
    I = I(1:2:size(I,1), 1:2:size(I,2));

    I = createIntegralImage(I);

    % run over patches of size 19 x 19
    scores = zeros(size(I));
    for i = 1:size(I,1)-18
        for j = 1:size(I,2)-18
            patch = I(i:i+18, j:j+18);
            scores(i,j) = haar.haarFeaturesCompute(patch);
        end
    end

end

