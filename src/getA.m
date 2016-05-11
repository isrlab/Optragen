% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function A = getA(OutputSequence,lcFunc)

len = length(OutputSequence);
A = zeros(1,len);

for j=1:length(lcFunc.Tnames)
    I = strcmp(lcFunc.Tnames{j},OutputSequence);
    if size(I)~=[1 1]
        error('Bug detected: I is not scalar');
    end
    eval(['tmp = ' lcFunc.grad{j} ';']);
    A(I) = tmp;
end


