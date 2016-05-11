% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function ret = reconfigureHL(prbInfo,newHL)

if ~isnumeric(newHL)
	error('Expecting numeric array for argument 2');
end

if ~isfield(prbInfo.optparam,'HL') | ~isfield(prbInfo.optparam,'bps') | ~isfield(prbInfo.optparam,'nbps')
    error('Illegal input type for argument 1');
end


ret = prbInfo;

ret.optparam.HL = newHL(end);
ret.optparam.bps = newHL;
ret.optparam.nbps = length(newHL);

