% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
function ColMat = getCollocMatrix(optparam)
% Returns the collocation matrix in the return variable.
% The return variable has the dimension of the number of trajectories
% Each entry has a data structure called "Data" which is a 3 dimensional
% matrix. The dimensions are (maxderiv,nbps,ncoef) for every trajectory
% defined in the problem.

for i=1:optparam.nout 
    ncoef = optparam.ninterv(i)*(optparam.order(i)-optparam.smoothness(i))+optparam.smoothness(i);
    knots = linspace(0,optparam.HL,optparam.ninterv(i)+1);
    augknots = augknt(knots,optparam.order(i),optparam.order(i)-optparam.smoothness(i));
    augbps = ones(optparam.maxderiv(i),1)*optparam.bps;
    [v1,v2] = size(augbps);
    augbps = sort(reshape(augbps,v1*v2,1));
    Mat = spcol(augknots,optparam.order(i),augbps);
    Mat = reshape(Mat,optparam.maxderiv(i),optparam.nbps,ncoef);    
    ColMat(:,:,i).Data = Mat;
end

