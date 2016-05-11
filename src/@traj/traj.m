% =======================================================================
%   Nonlinear Path Planning Toolbox v 1.0
%   Copyright (c) 2004 by                
%   Raktim Bhattacharya, (raktim@cds.caltech.edu)
%   California Institute of Technology               
%   Control and Dynamical Systems 
%   All right reserved.                
% =======================================================================

function ret = traj(ninterv,smoothness,order)
% Trajectory class constructor
%   T = traj(ninterv,smoothness,order) creates a Trajectory object from
%   the argument list. 
if nargin ~=3
    error('Usage: T = traj(ninterv,smoothness,order)');
else
   T.ninterv = ninterv;
   T.smoothness = smoothness;
   T.order = order;
   T.nderiv = 0;
   T.derivof  = [];    
   ret = class(T,'traj');
end