% =======================================================================
%   Nonlinear Path Planning Toolbox v 1.0
%   Copyright (c) 2004 by                
%   Raktim Bhattacharya, (raktim@cds.caltech.edu)
%   California Institute of Technology               
%   Control and Dynamical Systems 
%   All right reserved.                
% =======================================================================

function cost = cost_cFunction(func)


N = get(func,'nFunc');
name = get(func,'name');

if N~=1
    error('Cost defined by ANSI C function (%s) should return scalar values.',name);
end

% Check signature list of the cFunction
% It should match that required by nonlinear constraints

CI.grad = [];
CI.func = func;
CI.Tnames = get(func,'varList');