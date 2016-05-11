% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function LinCon = getNlpLinearA(optparam,ColMat);

TrajMat = [];
for i=1:optparam.nbps
    M = [];
    for j=1:optparam.nout
        ncoef = size(ColMat(j).Data,3);
        tmpMat = reshape(ColMat(j).Data(:,i,:),optparam.maxderiv(j),ncoef);
        M = sparse(diagonalise(M,tmpMat));
    end
    TrajMat(i).M = M;
end

InitMat = TrajMat(1).M;
FinalMat = TrajMat(end).M;

A = sparse([]);
lb = []; ub = [];

if optparam.nlic ~= 0
     A = [A;optparam.lic_A*InitMat];
     lb = [lb;optparam.lic_lb'];
     ub = [ub;optparam.lic_ub'];
end


if optparam.nltc ~= 0
    for i=1:optparam.nbps
         A = [A;optparam.ltc_A*TrajMat(i).M];
         lb = [lb;optparam.ltc_lb'];
         ub = [ub;optparam.ltc_ub'];
    end
end

if optparam.nlfc ~= 0
    A = [A;optparam.lfc_A*FinalMat];
    lb = [lb;optparam.lfc_lb'];
    ub = [ub;optparam.lfc_ub'];
end

LinCon.A = A;
LinCon.lb = lb;
LinCon.ub = ub;

