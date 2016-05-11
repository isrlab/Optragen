% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function S = getWorkSpaceTrajNames;

wkspvars = evalin('base','whos');

WV = {wkspvars.class};
I = strcmp(WV,'traj');
trajIndex = find(I==1);
S = {wkspvars(trajIndex).name};



