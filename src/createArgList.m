% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
function argList = createArgList(OutputSequence)
argList = sprintf('%s,',OutputSequence{:});
argList = argList(1:end-1); % Remove the last comma
