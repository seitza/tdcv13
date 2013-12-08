clear all;
close all;
clc;

test1 = [5 2;
         3 6];
output1 = [5 7; 8 16];   
int1 = create_integral_image(test1);
assert(isequal(int1,output1));

test2 = [5 2 5 2;
    3 6 3 6;
    5 2 5 2;
    3 6 3 6];
output2 = [5 7 12 14;
    8 16 24 32;
    13 23 36 46;
    16 32 48 64];
int2 = create_integral_image(test2);
assert(isequal(int2,output2));
fprintf('testing of integral image was successful!\n');


