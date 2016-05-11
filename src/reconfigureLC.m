% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function [ret] = reconfigureLC(prbInfo,C,lb,ub)

if nargin~=4
    error('Usage:  [prbInfo] = reconfigureLC(prbInfo,constr,lb,ub);');
end

if ~isa(C,'constraint')
    error('Expecting a constraint object for argument 3');
end

if ~isnumeric(lb) | ~isnumeric(ub)
    error('Numeric arrays expected for argument 3 and 4');
end

lcIndex = findLinearConstraints(C);
if isempty(lcIndex)
    error('No linear constraints found');
end

C1 = C(lcIndex);
len = length(lcIndex);

if length(lb) ~= len | length(ub) ~= len
    error('Argument 3 and 4 must be the same size as argument 2');
end

ret = prbInfo;

OutputSeq = createOutputSequence(ret.OutputInfo);
for j=1:len
    type = get(C1(j),'type');
    LC = get(C1(j),'func');
    A = getA(OutputSeq,LC);
    
    switch type
        case 'initial'
            index = [];
            for i=1:ret.optparam.nlic
                if A==ret.optparam.lic_A(i,:)
                    index = i;
                    break;
                end
            end
            if isempty(index)
                error('Unknown linear initial constraint specified');
            else
                ret.optparam.lic_lb(index) = lb(j);
                ret.optparam.lic_ub(index) = ub(j);
            end
        case 'trajectory'
            index = [];
            for i=1:ret.optparam.nltc
                if A==ret.optparam.ltc_A(i,:)
                    index = i;
                    break;
                end
            end
            if isempty(index)
                error('Unknown linear trajectory constraint specified');
            else
                ret.optparam.ltc_lb(index) = lb(j);
                ret.optparam.ltc_ub(index) = ub(j);
            end            
        case 'final'
            index = [];
            for i=1:ret.optparam.nlfc
                if A==ret.optparam.lfc_A(i,:)
                    index = i;
                    break;
                end
            end
            if isempty(index)
                error('Unknown linear final constraint specified');
            else
                ret.optparam.lfc_lb(index) = lb(j);
                ret.optparam.lfc_ub(index) = ub(j);
            end
        otherwise
            error('Unexpected error: Illegal linear constraint type');
    end
end

ret.optparam.lb = [ret.optparam.lic_lb';
               ret.optparam.ltc_lb';
               ret.optparam.lfc_lb';
               ret.optparam.nlic_lb';
               ret.optparam.nltc_lb';
               ret.optparam.nlfc_lb'];

ret.optparam.ub = [ret.optparam.lic_ub';
               ret.optparam.ltc_ub';
               ret.optparam.lfc_ub';
               ret.optparam.nlic_ub';
               ret.optparam.nltc_ub';
               ret.optparam.nlfc_ub'];
