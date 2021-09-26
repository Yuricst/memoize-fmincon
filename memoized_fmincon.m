function [u,fval,exitflag,output] = ...
    memoized_fmincon(fitness, u0, lb, ub, opts)
% =================================================== %
% Memoized wrapper to fmincon
%
% Yuri Shimane, 2021/09/26
% Georgia Institute of Technology
%
% INPUT
%   fitness : callable
%   u0      : optimoptions handle
%   lb      : lower bounds on decision vector
%   ub      : upper bounds on decision vector
%   opts    : optimoptions
%
% EXAMPLE
% opts = optimoptions('fmincon','Display','iter','Algorithm','sqp');
% [u,fval,exitflag,output] = ...
%     memoized_fmincon(@fitness, x0, lb, ub, opts);
%
% =================================================== %

% declare global variables for preventing unecessary dynamics computation
uLast = [];
fvalLast = [];
gradfLast = [];
cLast = [];
ceqLast = [];
gradcLast = [];
gradceqLast = [];

% objective function, nested below
ofun = @objfun;
% constraint function, nested below
cfun = @nlcon;

% call fmincon
[u,fval,exitflag,output] = fmincon(ofun,u0,[],[],[],[],lb,ub,cfun,opts);

% ... nested functions below ... %
    % ===== objective function ===== %
    function [fval,gradf] = objfun(u)
        % check if computation is necessary
        if ~isequal(u,uLast)
            % if u is not equal to uLast, run objective and constraint
            [fvalLast,gradfLast,cLast,ceqLast,gradcLast,gradceqLast] = fitness(u);
            % update u
            uLast = u;
        end
        % return objective function value and store updated value
        fval = fvalLast;
        gradf = gradfLast;
    end

    % ===== non-linear constraint function ===== %
    function [c,ceq,gradc,gradceq] = nlcon(u)
        % check if computation is necessary
        if ~isequal(u,uLast)
            % if u is not equal to uLast, run objective and constraint
            [fvalLast,gradfLast,cLast,ceqLast,gradcLast,gradceqLast] = fitness(u);
            % update u
            uLast = u;
            uLast = u;
        end
        % return objective function value and store updated value
        c = cLast;
        ceq = ceqLast;
        gradc = gradcLast;
        gradceq = gradceqLast;
    end

% ============================== %   
end




