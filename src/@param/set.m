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
    case 'varname'
        if ischar(val)
            a.varname = val;
        else
            error('Character string expected');
        end
    case 'value'
        if isnumeric(val) & size(val) == [1,1]
            a.value = val;
        else
            error('Numeric scalar expected');
        end
    otherwise
        error('Asset properties: varname, value')
    end
end