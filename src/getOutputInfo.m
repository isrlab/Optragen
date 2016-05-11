% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function ret = getOutputInfo(TrajList);
% Trajectory list contains no repetitions.
ret = [];

nvar = 0;
len = length(TrajList);

% Get order, smoothness, and ninterv
% ==================================
for i=1:len
    v = get(TrajList(i).traj,'derivof');
    if isempty(v)
        nvar = nvar + 1;
        ret(nvar).ninterv = get(TrajList(i).traj,'ninterv');
        ret(nvar).smoothness = get(TrajList(i).traj,'smoothness');
        ret(nvar).order = get(TrajList(i).traj,'order');
        ret(nvar).name  = TrajList(i).varname;
        ret(nvar).maxderiv = 0;
    end
end

% Get maxdriv
% ===========
for i=1:len
    v = get(TrajList(i).traj,'derivof');
    if ~isempty(v)
        I = strcmp({ret.name},v);
        trajIndex = find(I==1); % This should always be a scalar.
        if isempty(trajIndex)
            error('Derivatives of unknown trajectory objects encountered');
        end
        ret(trajIndex).maxderiv = ret(trajIndex).maxderiv + 1;
        
        nderiv = get(TrajList(i).traj,'nderiv');
        ret(trajIndex).derivName{nderiv} = TrajList(i).varname;
    end
end
        
        
        

        








        
        
        