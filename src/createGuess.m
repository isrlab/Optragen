% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
function xinit = createGuess(x,hl,Xval);

if ~isa(x,'traj')
    error('First argument must be a trajectory object');
end

[m1,n1] = size(hl);
l1 = length(hl);
if l1 ~= (m1*n1)
    error('Vector expected for hl');
end


[m2,n2] = size(Xval);
l2 = length(Xval);
if l2 ~= (m2*n2)
    error('Vector expected for Xval');
end


if length(hl) ~= length(Xval)
    error('hl and Xval must be vectors of equal length');
end

n = get(x,'ninterv');
s = get(x,'smoothness');
r = get(x,'order');


T0 = hl(1);
Tend = hl(end);
knt = linspace(T0,Tend,n+1);
augknots=augknt(knt,r,r-s);
xinit = spap2(augknots, r, hl, Xval );    