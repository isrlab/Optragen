function HL = nodesCGL(x0,xf,N)
% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
% Chebyshev Gauss Lobatto collocation points.

N = N-1;
i=[0:N];
TL = sort(cos(pi*i/N));
HL = ((xf-x0)*TL + (x0+xf))/2;



