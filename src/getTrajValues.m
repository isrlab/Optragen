% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function [z] = getTrajValues(B,x);
% z : rows are time values, col mat OutputSequence
z = [];

[nTraj,ncoef,nbps] = size(B);

for i=1:nbps    
    B1 = reshape(B(:,:,i),nTraj,ncoef);
    z = [z B1*x];
end
