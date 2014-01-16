function [ samples ] = sample( image, grid, weight )

samples = interp2(1:size(image,2),1:size(image,1),image,grid(:,1),grid(:,2),'linear',0);  

samples = (samples-mean(samples))/std(samples);
samples = samples+weight*rand(size(samples));

end

