# memoize-fmincon
Memoized version of fmincon with MATLAB

The `fmincon` function takes as input the objective and constraints functions as separate inputs; as such, if an expensive comptuation result is used in both expressions, it is preferable to keep use a single `fitness` function that comptutes both the objective and the constraints values. 
The `memoized_fmincon()` function in this repo is a wrapper to `fmincon` that allows the user to pass a single `fitness` function and optimize.

### Example

The fitness function must have the following signature:

```MATLAB
function [fval,gradf,c,ceq,gradc,gradceq] = fitness(x)
  fval = (1-x(1))^2 + 100*(x(2) - x(1)^2)^2;  % objective

  c(1,1) = (x(1) - 1)^3 - x(2) + 1;   % constraints
  c(2,1) = x(1) + x(2) - 2;

  ceq = [];

  gradf = [];
  gradc = [];
  gradceq = [];
end
```

Note that in this simple example, there are no shared terms within the computation of the obejctive and the constraints, so the memoization is not necessary. This simple example is rather intended to demonstrate the usage of the `memoized_fmincon()` function. 

The main script should look as follows:

```MATLAB
clear; close all; clc;

c = zeros(2,1);  % space for constraints
x0 = rand(2,1);

lb = [-1.5, -0.5];
ub = [1.5, 2.5];
opts = optimoptions('fmincon','Display','iter','Algorithm','sqp');

% run fmincon
[u,fval,exitflag,output] = memoized_fmincon(@fitness, x0, lb, ub, opts);

fprintf("Optimum x: %f, %f\n", u);
```

This example is from `example_constrained.m`. 
