% EE454_Project
% main.m
% by Alex Htut

clear all; close all; clc;

input = xlsread('EE454_Project_InputData.xlsx', 1);
Y = Y_matrix_function(input);

% setting up G and B matrices
% Y is always a square matrix
[rols, ~] = size(Y);
G = zeros(rols);
B = zeros(rols);
[G,B] = G_B_matrices_function(Y);