% =======================================================================
%   Nonlinear Path Planning Toolbox v 1.0
%   Copyright (c) 2004 by                
%   Raktim Bhattacharya, (raktim@cds.caltech.edu)
%   California Institute of Technology               
%   Control and Dynamical Systems 
%   All right reserved.                
% =======================================================================

function display(a)
% DISPLAY(a) Display an asset object

[m,n] = size(a);

len = m*n;
disp('Parameter(s):');
for i=1:len
    disp([' ' a(i).varname ' = ' num2str(a(i).value)]);
end

    