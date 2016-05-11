% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function nlcIndex = findNonlinearConstraints(Constr)

nlcIndex = [];
len = length(Constr);

for i=1:len
    c = get(Constr(i),'func');
    
    if isa(c.func,'cFunction') | isa(c.func,'mFunction')
        flag = 1;
    else
        len1 = length(c.grad);
        flag = 0;
        for j=1:len1
            if ~isempty(symvar(c.grad{j})) % Found a nonlinear constraint
                flag = 1;
                break;
            end
        end
    end
    if flag == 1 % Save the nonlinear constraint index
        nlcIndex = [nlcIndex i];
    end 
end
