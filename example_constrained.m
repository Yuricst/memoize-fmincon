%% Example constrianed problem
% Yuri Shimane, 2021.09.26
% house keep
clear; close all; clc;

c = zeros(2,1);  % space for constraints
x0 = rand(2,1);

lb = [-1.5, -0.5];
ub = [1.5, 2.5];
opts = optimoptions('fmincon','Display','iter',...
    'Algorithm','sqp');

[u,fval,exitflag,output] = ...
    memoized_fmincon(@fitness, x0, lb, ub, opts);
fprintf("Optimum x: %f, %f\n", u);

% fitness function
function [fval,gradf,c,ceq,gradc,gradceq] = fitness(x)
fval = (1-x(1))^2 + 100*(x(2) - x(1)^2)^2;

c(1,1) = (x(1) - 1)^3 - x(2) + 1;
c(2,1) = x(1) + x(2) - 2;

ceq = [];

gradf = [];
gradc = [];
gradceq = [];
end