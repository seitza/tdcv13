% compare median_filter against MATLAB 
clear all;
close all;
clc;

s = [3 3];
I = double(imread('lena.gif'))/255.0;

I_median_matlab = medfilt2(I,s);
I_median = median_filter(I,s);

diff = sum(sum((I_median_matlab - I_median).^2));
fprintf('Difference between Matlab and custom implementation: %e\n', diff);
fprintf('--------------------------------------------------------------\n');

if diff < eps
    fprintf('TEST PASSED!\n');
else
    fprintf('TEST FAILED!\n');
end

    


