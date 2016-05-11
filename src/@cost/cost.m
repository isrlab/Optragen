% =======================================================================
%   Nonlinear Path Planning Toolbox v 1.0
%   Copyright (c) 2004 by                
%   Raktim Bhattacharya, (raktim@cds.caltech.edu)
%   California Institute of Technology               
%   Control and Dynamical Systems 
%   All right reserved.                
% =======================================================================

function ret = cost(func,type)
%
% This function defines the initial cost function
% func definition can be either
%           a) Character string containing the function
%           b) mFunction object
%           c) cFunction object

% =================== Error Checking for Input Data ===================

if nargin~=2
    error('Usage: costObj = cost(function,type);');
end


if ~isa(type,'char')
    error('Expecting character array for type');
end

TYPES = {'initial','trajectory','final'};
ii = strmatch(lower(type),TYPES,'exact');
if isempty(ii)
    error('Cost <type> must be one of the following: initial, trajectory, final');
end

% =========================================================================


if isa(func,'char')
    CI = cost_char(func);
elseif isa(func,'mFunction')
    CI = cost_mFunction(func);
elseif isa(func,'cFunction')
    CI = cost_cFunction(func);
else
    error('Illegal data type in first argument.');
end

costObj.func = CI; 
costObj.type = lower(type); 

ret = class(costObj,'cost');

    