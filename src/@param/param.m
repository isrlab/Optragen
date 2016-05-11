% =======================================================================
%   Nonlinear Path Planning Toolbox v 1.0
%   Copyright (c) 2004 by                
%   Raktim Bhattacharya, (raktim@cds.caltech.edu)
%   California Institute of Technology               
%   Control and Dynamical Systems 
%   All right reserved.                
% =======================================================================

function ret = param(varname)
% Constructor for param class.
%  varname is a string containing the name of the parameter
%  value is a numeric constant that is associated with the parameter
%
%
%
if nargin ~=2
    error('Usage: paramObj = param(varname);');
else
   
   if ~ischar(varname)
       error('Expecting string constant for first argument');
   end
    
   P = [];
   P.varname = varname;
   ret = class(P,'param');
   
end