% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function init = initialiseTraj(prbInfo,C,N)

if ~iscell(C)
	error('Expecting cell array of strings for argument 2');
else
	for i=1:length(C)
		if ~ischar(C{i})
			error('Expecting cell array of strings for argument 2');
		end
	end
end

if ~iscell(N)
	error('Expecting numeric cell array for argument 3');
else
	for i=1:length(N)
		if ~isnumeric(N{i})
			error('Expecting numeric cell array for argument 3');
		end
		if size(N{i},2)~=2
		error('Expecting numeric arrays with two column');
		end
	end
end

if length(C) ~= length(N)
	error('Lengths of cell arrays in argument 1 and 2 must be the same');
end


optparam = prbInfo.optparam;
ncoef = [];
index = [];
for j=1:length(C)
	name = C{j};
	for i=1:optparam.nout
    		ncoef(i) = optparam.ninterv(i)*(optparam.order(i)-optparam.smoothness(i))+optparam.smoothness(i);
    		if strcmp(name,prbInfo.OutputInfo(i).name);
        		index = i;
        		break;
    		end
	end
	
	if isempty(index)
    	error('Unknown trajectory specified');
	end

	T = N(:,j);
	b = sum(ncoef);
	a = b-ncoef(end)+1;
	knots = linspace(0,optparam.HL,optparam.ninterv(index)+1);
	augknots=augknt(knots,optparam.order(index),optparam.order(index)-optparam.smoothness(index));
	t = N{index}(:,1);
	x = N{index}(:,2);

	order = optparam.order(index);
	ninterv = optparam.ninterv(index);
	sp = spap2(ninterv,order,t,x);

	len = b-a+1;
	X0 = zeros(1,len);
	
	X = fminunc(@objectiveFcn,X0,[],augknots,sp,t);

	keyboard;
end
	

	
	









