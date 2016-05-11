% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================

function optparam = getOptParam(OutputInfo, Cost, Constr, HL, ParamList)

optparam = [];

optparam.nout = length(OutputInfo);
optparam.HL   = HL(end);
optparam.user_def_HL = 1;  % This will be always true for calls made from MATLAB
optparam.bps  = HL;
optparam.nbps = length(HL);

optparam.user_def_IC = 1;  % True when called from MATLAB
optparam.nIC = 0;
for i=1:optparam.nout
    optparam.order(i) = OutputInfo(i).order;
    optparam.smoothness(i) = OutputInfo(i).smoothness;
    optparam.ninterv(i) = OutputInfo(i).ninterv;
    optparam.maxderiv(i) = OutputInfo(i).maxderiv + 1; % Plus one because of maxderiv definition mismatch between nlpp,ntgml and ntg
    optparam.nIC = optparam.nIC + optparam.ninterv(i)*(optparam.order(i)-optparam.smoothness(i))+optparam.smoothness(i);
end
optparam.IC = zeros(1,optparam.nIC); % Will be filled when solver is called.


optparam.randomScale = 0; % Initial Conditions will always be specified.
optparam.outputFormat = 0 ;% Always coefficients
optparam.fname = [];  % No output filename needed.


OutputSequence = createOutputSequence(OutputInfo);

% Linear Constraint Details
% =========================
lcIndex = findLinearConstraints(Constr);
optparam.nlic = 0;
optparam.nltc = 0;
optparam.nlfc = 0;
optparam.nlgc = 0;

optparam.lic_lb = []; optparam.lic_A = []; optparam.lic_ub = [];
optparam.ltc_lb = []; optparam.ltc_A = []; optparam.ltc_ub = [];
optparam.lfc_lb = []; optparam.lfc_A = []; optparam.lfc_ub = [];
optparam.lgc_lb = []; optparam.lgc_A = []; optparam.lgc_ub = [];

for i=1:length(lcIndex)
    ii = lcIndex(i);
    lcType = get(Constr(ii),'type');
    lcFunc = get(Constr(ii),'func');
    switch lcType
        case 'initial'
            optparam.nlic = optparam.nlic + 1;
            optparam.lic_lb(optparam.nlic) = lcFunc.lb;
            optparam.lic_ub(optparam.nlic) = lcFunc.ub;
            optparam.lic_A(optparam.nlic,:) = getA(OutputSequence,lcFunc); % getA(...) returns a row vector
        case 'trajectory'
            optparam.nltc = optparam.nltc + 1;
            optparam.ltc_lb(optparam.nltc) = lcFunc.lb;
            optparam.ltc_ub(optparam.nltc) = lcFunc.ub;
            optparam.ltc_A(optparam.nltc,:) = getA(OutputSequence,lcFunc);% getA(...) returns a row vector
        case 'final'
            optparam.nlfc = optparam.nlfc + 1;
            optparam.lfc_lb(optparam.nlfc) = lcFunc.lb;
            optparam.lfc_ub(optparam.nlfc) = lcFunc.ub;
            optparam.lfc_A(optparam.nlfc,:) = getA(OutputSequence,lcFunc);% getA(...) returns a row vector
        case 'galerkin'
            optparam.nlgc = optparam.nlgc + 1;
            optparam.lgc_lb(optparam.nlgc) = lcFunc.lb;
            optparam.lgc_ub(optparam.nlgc) = lcFunc.ub;
            optparam.lgc_A(optparam.nlgc,:) = getA(OutputSequence,lcFunc);% getA(...) returns a row vector
        otherwise
            error('Illegal Linear Constraint Type Specified');
    end
end

% Nonlinear Constraint Details
% ============================
nlcIndex = findNonlinearConstraints(Constr);
optparam.nnlic = 0;
optparam.nnltc = 0;
optparam.nnlfc = 0;
optparam.nnlgc = 0;

optparam.nlic_lb = []; optparam.nlic_ub = [];
optparam.nltc_lb = []; optparam.nltc_ub = [];
optparam.nlfc_lb = []; optparam.nlfc_ub = [];
optparam.nlgc_lb = []; optparam.nlgc_ub = [];

for i=1:length(nlcIndex)
    ii = nlcIndex(i);
    nlcType = get(Constr(ii),'type');
    nlcFunc = get(Constr(ii),'func');
    switch nlcType
        case 'initial'
            optparam.nnlic = optparam.nnlic + 1;
            optparam.nlic_lb =  [optparam.nlic_lb nlcFunc.lb];
            optparam.nlic_ub =  [optparam.nlic_ub nlcFunc.ub];
        case 'trajectory'
            optparam.nnltc = optparam.nnltc + 1;
            optparam.nltc_lb =  [optparam.nltc_lb nlcFunc.lb];
            optparam.nltc_ub =  [optparam.nltc_ub nlcFunc.ub];
        case 'final'
            optparam.nnlfc = optparam.nnlfc + 1;
            optparam.nlfc_lb =  [optparam.nlfc_lb nlcFunc.lb];
            optparam.nlfc_ub =  [optparam.nlfc_ub nlcFunc.ub];
        case 'galerkin'
            optparam.nnlgc = optparam.nnlgc + 1;
            optparam.nlgc_lb =  [optparam.nlgc_lb nlcFunc.lb];
            optparam.nlgc_ub =  [optparam.nlgc_ub nlcFunc.ub];
        otherwise
            error('Illegal Nonlinear Constraint Type Specified');
    end
end


% Cost function Details
% =====================

optparam.nicf = 0;
optparam.ntcf = 0;
optparam.nfcf = 0;

for i=1:length(Cost)
    costType = get(Cost(i),'type');
    switch costType
        case 'initial'
            optparam.nicf = optparam.nicf + 1;
        case 'trajectory'
            optparam.ntcf = optparam.ntcf + 1;
        case 'final'
            optparam.nfcf = optparam.nfcf + 1;
        otherwise
            error('Illegal Cost Type Specified');
    end
end

% Make sure that there is only one cost function
% ==============================================
if optparam.nicf > 1
    error('More than one initial cost specified');
end

if optparam.ntcf > 1
    error('More than one trajectory cost specified');
end

if optparam.nfcf > 1
    error('More than one final cost specified');
end


optparam.lb = [optparam.lic_lb';
    optparam.ltc_lb';
    optparam.lfc_lb';
    optparam.nlic_lb';
    optparam.nltc_lb';
    optparam.nlfc_lb'];

optparam.ub = [optparam.lic_ub';
    optparam.ltc_ub';
    optparam.lfc_ub';
    optparam.nlic_ub';
    optparam.nltc_ub';
    optparam.nlfc_ub'];

