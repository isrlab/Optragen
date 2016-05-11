% =======================================================================
%   Nonlinear Path Planning Toolbox v 1.0
%   Copyright (c) 2004 by                
%   Raktim Bhattacharya, (raktim@cds.caltech.edu)
%   California Institute of Technology               
%   Control and Dynamical Systems 
%   All right reserved.                
% =======================================================================

function val = get(a,prop_name)
% GET Get asset properties from the specified object
% and return the value

switch prop_name
case 'func'
    val = a.func;
case 'type'
    val = a.type;
case 'tag'
    val = a.tag;
otherwise
    error([prop_name,' Is not a valid asset property'])
end