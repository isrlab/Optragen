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
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
    case 'ninterv'
        if isnumeric(val) & size(val) == [1,1];
            a.ninterv = uint32(val);
        else
            error('Scalar integer expected');
        end
            
    case 'smoothness'
        if isnumeric(val) & size(val) == [1,1];
            a.smoothness = uint32(val);
        else
            error('Scalar integer expected');
        end
    case 'order'
        if isnumeric(val) & size(val) == [1,1];
            a.order = uint32(val);
        else
            error('Scalar integer expected');
        end
    case 'nderiv'
        error('Cannot change nderiv property directly');
    case 'derivof'
        error('Cannot change derivof property directly');
    otherwise
        error('Asset properties: ninterv,mult,order')
    end
end