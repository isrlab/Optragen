% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function constr = constraint_char(lb,func,ub)
%
% This function defines the initial cost function
% Function is defined as a character array.

% Get all the trajectories from the workspace

if length(lb) > 1 | length(ub) > 1
    error('Bounds must be scalars for analytical constraint functions');
end

varnames = symvar(func);

Tnames = getWorkSpaceTrajNames;

fvars = [];
for i=1:length(varnames)
    I = strcmp(varnames{i},Tnames);
    if sum(I)>0 
        fvars = [fvars,{varnames{i}}];
    end
end

grad = getGradient(func,fvars);   % Char cell array

constr.grad = grad;
constr.func = func;
constr.Tnames = fvars;
constr.lb = scaleInf(lb);
constr.ub = scaleInf(ub);




