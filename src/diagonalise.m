% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function out = diagonalise(Mat1,Mat2);

[m1,n1] = size(Mat1);
[m2,n2] = size(Mat2);


if isempty(Mat1) & isempty(Mat2)
    out = [];
elseif isempty(Mat1)
    out = Mat2;
elseif isempty(Mat2)
    out = Mat1;
else 
    out = [Mat1 zeros(m1,n2); zeros(m2,n1) Mat2];
end
