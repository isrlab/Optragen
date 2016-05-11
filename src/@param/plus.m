% =======================================================================
%   Nonlinear Path Planning Toolbox v 1.0
%   Copyright (c) 2004 by                
%   Raktim Bhattacharya, (raktim@cds.caltech.edu)
%   California Institute of Technology               
%   Control and Dynamical Systems 
%   All right reserved.                
% =======================================================================

function T = plus(T1,T2)

[m1,n1] = size(T1);
[m2,n2] = size(T2);

if (m1~=1 | m2~=1)
    error('Arguments must be row vectors');
end

T = [T1 T2];

