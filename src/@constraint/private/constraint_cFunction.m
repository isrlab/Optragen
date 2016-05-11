% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function constr = constraint_cFunction(lb,func,ub)
%
% This function defines the initial cost function
% Function is defined as a character array.

% Get all the trajectories from the workspace

N = get(func,'nFunc');

if length(lb) ~= N | length(ub) ~= N
    error('Bounds must be scalars for analytical constraint functions');
end

% Check signature list of the cFunction
% It should match that required by nonlinear constraints

constr.grad = [];
constr.func = func;
constr.Tnames = get(func,'varList');
constr.lb = scaleInf(lb);
constr.ub = scaleInf(ub);