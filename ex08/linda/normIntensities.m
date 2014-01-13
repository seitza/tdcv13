function [ normalized_intensities ] = normIntensities( intensities )

    normalized_intensities = intensities - mean(intensities);
    normalized_intensities = normalized_intensities ./ std(intensities);

end

