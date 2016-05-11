% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function lcIndex = findLinearConstraints(Constr)

lcIndex = [];
len = length(Constr);

for i=1:len
    c = get(Constr(i),'func');
    flag = 0;
    if isa(c.func,'cFunction') | isa(c.func,'mFunction')
        flag = 1;
    else
        len1 = length(c.grad);
        for j=1:len1
            if ~isempty(symvar(c.grad{j}))
                flag = 1;
                break;
            end
        end
    end
    if flag == 0
        lcIndex = [lcIndex i];
    end
end
