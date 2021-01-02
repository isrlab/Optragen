% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
function [F,Feq] = optragenConstraint(x)
global nlp;

z = getTrajValues(nlp.B,x);

% Initialize Constraint Variables
% ===============================
InlConstr = []; InlConstrGrad = [];
TnlConstr = []; TnlConstrGrad = [];
FnlConstr = []; FnlConstrGrad = [];
GnlConstr = []; GnlConstrGrad = [];

%% Initial Constraint Functions
% =============================
z = full(z);
argList = sprintf('%f,',z(:,1)); argList = argList(1:end-1);

if nlp.nnlic ~= 0 % Constraints
    fcn = ['[f,df] = ' nlp.probName '_nlicf(' argList ');'];
    eval(fcn);
    InlConstr = f;
    InlConstrGrad = df*squeeze(nlp.B(:,:,1));
end

%% Integral Path Constraint Functions
% ===================================
if nlp.nnltc ~= 0 % Path constraints
    [nTraj,nCoeff,nbps] = size(nlp.B);
    argList = sprintf('z(%d,:),',[1:nTraj]);
    argList = argList(1:end-1);
    fcn = ['[f,df] = ' nlp.probName '_nltcf(' argList ');'];
    eval(fcn);
    TnlConstr = reshape(f',nlp.nnltc*nlp.nbps,1);
    V1 = reshape(repmat(df,[nCoeff 1 1]),[nlp.nnltc*nTraj*nCoeff nbps]);
    V2 = repmat(reshape(nlp.B,[nTraj*nCoeff nbps]),[nlp.nnltc 1]);
    V3 = reshape(V1.*V2,[nTraj nCoeff nlp.nnltc nbps]);
    V4 = shiftdim(sum(V3,1));
    TnlConstrGrad = reshape(permute(V4,[3 2 1]),[nbps*nlp.nnltc nCoeff]);
end

%% Galerkin Constraints
% =====================
if nlp.nnlgc ~= 0
    nBasis = size(nlp.BasisFcn,2);
    [nTraj,nCoeff,nbps] = size(nlp.B);
    argList = sprintf('z(%d,:),',[1:nTraj]);
    argList = argList(1:end-1);
    fcn = ['[f,df] = ' nlp.probName '_nlgcf(' argList ');'];
    eval(fcn);

    V1 = repmat(f',1,nBasis);
    V2 = reshape(repmat(nlp.BasisFcn,nlp.nnlgc,1),nlp.nbps,nlp.nnlgc*nBasis);
   
    GnlConstr = trapz(nlp.bps,V1.*V2,1)';
    
    V1 = reshape(repmat(df,[nCoeff 1 1]),[nlp.nnlgc*nTraj*nCoeff nbps]);
    V2 = repmat(reshape(nlp.B,[nTraj*nCoeff nbps]),[nlp.nnlgc 1]);
    V3 = reshape(V1.*V2,[nTraj nCoeff nlp.nnlgc nbps]);
    V4 = reshape(shiftdim(sum(V3,1)),nCoeff*nlp.nnlgc,nbps);

    V5 = repmat(V4',1,nBasis);
    V6 = reshape(repmat(nlp.BasisFcn,nCoeff*nlp.nnlgc,1),nlp.nbps,nlp.nnlgc*nCoeff*nBasis);
    
    GnlConstrGrad = reshape(trapz(nlp.bps,V5.*V6,1),nCoeff,nBasis*nlp.nnlgc)';
end

%% Final Constraint Functions
% ===========================
argList = sprintf('%f,',z(:,end)); argList = argList(1:end-1);

if nlp.nnlfc ~= 0 % Constraints
    fcn = ['[f,df] = ' nlp.probName '_nlfcf(' argList ');'];
    eval(fcn);
    FnlConstr = f;
    FnlConstrGrad =  df'*squeeze(nlp.B(:,:,end));
end

ii = find(nlp.nlb ==  nlp.nub);
jj = find(nlp.nlb ~=  nlp.nub);


nlConstr = [InlConstr;TnlConstr;FnlConstr;GnlConstr];

Feq = nlConstr(ii);

F = [nlConstr(jj) - nlp.nub(jj);
     -nlConstr(jj) + nlp.nlb(jj)];
 
% nlConstrGrad = [InlConstrGrad;TnlConstrGrad;FnlConstrGrad;GnlConstrGrad];
% 
% if nargout > 1 
%     G = full([nlConstrGrad;-nlConstrGrad]);
% else
%     G = [];
% end
