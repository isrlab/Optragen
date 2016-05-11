% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
function grad = getGradient(func,Tnames)
func1 = vpa(func,5);
len = length(Tnames);
for i=1:len   
   var = char(Tnames{i});
   %grad(i) = {char(maple('diff',func,var))}; % with Maple toolbox
   grad(i) = {char(diff(sym(func),var))}; % with Matlab symbolic toolbox
end


    
