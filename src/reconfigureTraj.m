% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function ret = reconfigureTraj(prbInfo,tname,C,N)

if ~ischar(tname)
    error('Expecting a character string for argument 2');
end

if ~isnumeric(N)
    error('Expecting a numeric array for argument 4');
end

if ~iscell(C)
    error('Expecting a cell array of strings for argument 3');
end

if length(C) ~= length(N)
    error('Argument 3 and 4 must be arrays with same length')
end

for i=1:length(C)
    if ~ischar(C{i})
        error('Expecting a cell array of strings for argument 3');
    end
end

if ~isfield(prbInfo,'OutputInfo') | ~isfield(prbInfo,'optparam')
    error('Illegal input type for argument 1');
end


ret = prbInfo;

tn = {ret.OutputInfo.name};

I = strcmp(tn,tname);
if sum(I) == 0
    error('Unknown trajectory variable specified');
end

index = find(I==1);

len = length(C);

for i=1:len
    switch(C{i});
        case 'ninterv'
            ret.optparam.ninterv(index) = N(i);
        case 'order'
            ret.optparam.order(index) = N(i);
        case 'smoothness'
            ret.optparam.smoothness(index) = N(i);
        otherwise
            error('Illegal trajectory parameter specified');
    end
end

% Recompute related parameters
% ============================

ret.optparam.nIC = 0;
for i=1:ret.optparam.nout
    ret.optparam.nIC = ret.optparam.nIC + ret.optparam.ninterv(i)*(ret.optparam.order(i)-ret.optparam.smoothness(i))+ret.optparam.smoothness(i);
end
ret.optparam.IC = zeros(1,ret.optparam.nIC);
          
    
    
    
    
    
        