clc; clear; close all;

%% ex3

load('ex2_results');

R0 = eye(3,3); % initial rotation matrix

T0 = zeros(3,1); % initial translation vector

% example for fminsearch from bmt
%alpha = fminsearch(@(alpha) cost_function(alpha, I_orig, D, R), alpha0 );