% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function OutputSequence = createOutputSequence(OutputInfo)
len = length(OutputInfo);
OutputSequence = [];
for i=1:len
    OutputSequence = [OutputSequence {OutputInfo(i).name}];
    for j=1:OutputInfo(i).maxderiv
	 OutputSequence = [OutputSequence {OutputInfo(i).derivName{j}}];
    end
end
    
    
