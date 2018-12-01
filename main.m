% EE454_Project
% main.m
% by Alex Htut

clear all; close all; clc;

Y = Y_matrix_function('EE454_Project_InputData.xlsx');
[rols, cols] = size(Y);
G = zeros(rols);
B = zeros(cols);
[G,B] = G_B_matrices_function(Y);