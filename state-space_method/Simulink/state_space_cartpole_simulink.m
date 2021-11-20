clc
clear all
close all


%% Initialization
I =1;
M = 1;
m = 1;
l = 1;
b = 1;
g = 10;

%% Linearization

denom = I*(M+m) + M*m*l^2;

A = [0                   1                   0  0;
     0 (-(I+m*l^2)*b)/denom   (m^2*g*l^2)/denom  0;
     0                   0                   0  1;
     0      (-m*l*b)/denom (m*g*l)*(M+m)/denom  0];

B = [0; (I+m*l^2)/denom; 0; m*l/denom];

%% Controller

lambda = [-5,-4,-2+1i,-2-1i];
K = place(A,B,lambda);


