% This file tests the normalized_dlt function
clear all
clc;
close all;

ref_points = [10 13 45;
              20 23 35;
              1  1  1];
          
warped_points = [ 103 106 80;
                  301 305 229;
                  1 1 1];
              
H = normalized_dlt(ref_points, warped_points);
