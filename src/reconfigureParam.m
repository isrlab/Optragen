% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
function ret = reconfigureParam(prbInfo,C,N)

if ~isnumeric(N)
    error('Expecting a numeric array for argument 4');
end

if ~iscell(C)
    error('Expecting a cell array of strings for argument 3');
end

if length(C) ~= length(N)
    error('Argument 3 and 4 must be arrays with same length')
end

if ~isfield(prbInfo,'paramName') | ~isfield(prbInfo,'paramValue')
    error('Illegal input type for argument 1');
end

for i=1:length(C)
    if ~ischar(C{i})
        error('Expecting a cell array of strings for argument 3');
    end
end

ret = prbInfo;

pn = ret.paramName;
pv = ret.optparam.param;

len = length(C);

for i=1:len
    I = strcmp(pn,C{i});
    if sum(I)>1
        error('Repeated parameters in parameter list')
    end
   
    if sum(I) == 0
        error('Illegal parameter name specified');
    end
    
    index = find(I==1);
    
    if index>len
        error('Unexpected error : index > length(paramList)');
    end  
    ret.optparam.param(index) = N(i);
    ret.paramValue(index) = N(i);
end        
