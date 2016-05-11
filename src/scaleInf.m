% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function out = scaleInf(in)

nlppInfinity = exp(100);

index = find(isinf(in));

in1 = in(index);

pos = find(sign(in1)>0);
neg = find(sign(in1)<0);

in1(pos) =  nlppInfinity;
in1(neg) = -nlppInfinity;

out = in;
out(index) = in1;

out = reshape(out,[1 length(out)]); % Make it into a row vector