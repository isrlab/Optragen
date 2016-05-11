% =======================================================================
%   Nonlinear Path Planning Toolbox v 1.0
%   Copyright (c) 2004 by                
%   Raktim Bhattacharya, (raktim@cds.caltech.edu)
%   California Institute of Technology               
%   Control and Dynamical Systems 
%   All right reserved.                
% =======================================================================

function a = set(a,varargin)
% SET Set asset properties and return the updated object
property_argin = varargin;
disp('Cannot alter attributes of a cost object. Create a new cost object instead');
