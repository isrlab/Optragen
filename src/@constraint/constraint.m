function ret = constraint(lb,func,ub,type)
%
% This function defines the initial cost function
% func definition can be either
%           a) Character string containing the function
%           b) mFunction object
%           c) cFunction object

% =================== Error Checking for Input Data ===================

if nargin~=4
    error('Usage: constrObj = constraint(lb,func,ub,type);');
end



if ~isa(lb,'numeric')
    error('Expecting numeric array for lower bound');
end

if ~isa(ub,'numeric')
    error('Expecting numeric array for upper bound');
end

if ~isa(type,'char')
    error('Expecting character array for type');
end

TYPES = {'initial','trajectory','final','galerkin'};
ii = strmatch(lower(type),TYPES,'exact');
if isempty(ii)
    error('Constraint <type> must be one of the following: initial, trajectory, final, galerkin');
end

% ======================================================================================

if isa(func,'char')
    constr= constraint_char(lb,func,ub);
elseif isa(func,'mFunction')
    constr = constraint_mFunction(lb,func,ub);
elseif isa(func,'cFunction')
    constr = constraint_cFunction(lb,func,ub);
else
    error('Illegal data type in first argument.');
end

constrObj.func = constr; 
constrObj.type = lower(type); 
ret = class(constrObj,'constraint');

    