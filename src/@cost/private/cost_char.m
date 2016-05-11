% =======================================================================
%   Nonlinear Path Planning Toolbox v 1.0
%   Copyright (c) 2004 by                
%   Raktim Bhattacharya, (raktim@cds.caltech.edu)
%   California Institute of Technology               
%   Control and Dynamical Systems 
%   All right reserved.                
% =======================================================================

function CI = cost_char(func)
%
% This function defines the initial cost function
% Function is defined as a character array.

% Get all the trajectories from the workspace

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

CI.grad = grad;
CI.func = func;
CI.Tnames = fvars;

