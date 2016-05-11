% =======================================================================
%   Nonlinear Path Planning Toolbox v 1.0
%   Copyright (c) 2004 by                
%   Raktim Bhattacharya, (raktim@cds.caltech.edu)
%   California Institute of Technology               
%   Control and Dynamical Systems 
%   All right reserved.                
% =======================================================================

function ret = trajList(varargin)

ret = [];
for i = 1:nargin
    if ~isa(varargin{1},'traj')
        error('Only trajectory object are valid input arguments');
    end
    
    if size(varargin{1}) ~= [1 1]
        error('Only scalar trajectory objects are allowed');
    end   
    ret(i).varname = inputname(i);
    ret(i).traj    = varargin{i};
end
 
 List = {ret.varname};
 uniqueList = unique(List);
 
 if length(List)~= length(uniqueList)
     error('Only unique trajectory objects allowed in argument');
 end
