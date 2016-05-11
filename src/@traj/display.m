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
if (m>1 | n>1)
    disp(['Trajectory matrix of size [' num2str([m,n]) ']']);
else
    if isempty(a.derivof)
        derivof = '<none>';
        stg = sprintf(...
        ' ninterv: %d\n smoothness: %d\n order: %d\n nderiv: %d\n derivof: %s',...
        a.ninterv,a.smoothness,a.order,a.nderiv,derivof);
    disp(stg);
    else
        stg = sprintf(...
        ' nderiv: %d\n derivof: %s',...
        a.nderiv,a.derivof);
    disp(stg);
    end
end
    