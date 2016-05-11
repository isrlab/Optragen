% =======================================================================
%   Nonlinear Path Planning Toolbox v 1.0
%   Copyright (c) 2004 by                
%   Raktim Bhattacharya, (raktim@cds.caltech.edu)
%   California Institute of Technology               
%   Control and Dynamical Systems 
%   All right reserved.                
% =======================================================================

function Td = deriv(T);

if nargin~=1
    error('Usage: Td = deriv(T);');
end

if size(T) ~= [1 1]
    error('Argument Trajectory must be scalar');
end


if ~isa(T,'traj')
    error('First argument must be a trajectory object');
end

Td = T;

Td.ninterv = [];
Td.smoothness = [];
Td.order = [];
Td.nderiv = 0;
Td.derivof  = [];

md = get(T,'nderiv');
Td.nderiv = T.nderiv + 1;
if md == 0
    Td.derivof  = inputname(1);
else
    Td.derivof = T.derivof;
end
    