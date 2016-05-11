% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
function [F,G] = ocp2nlp_cost_and_constraint(x)
global nlp;

z = getTrajValues(nlp.B,x);

% Initialize Cost Variables
% ==========================
IObj = 0; IObjGrad = [];
trajOBJ = 0; trajOBJGrad = [];
FObj = 0; FObjGrad = [];

% Initialize Constraint Variables
% ===============================
InlConstr = []; InlConstrGrad = [];
TnlConstr = []; TnlConstrGrad = [];
FnlConstr = []; FnlConstrGrad = [];
GnlConstr = []; GnlConstrGrad = [];

%% Initial Cost & Constraint Functions
% ====================================
z = full(z);
argList = sprintf('%f,',z(:,1)); argList = argList(1:end-1);
if nlp.nicf ~= 0 % Costs
    fcn = ['[f,df] = ' nlp.probName '_icf(' argList ');'];
    eval(fcn);
    IObj = f;
    IObjGrad = df'*squeeze(nlp.B(:,:,1));
end

if nlp.nnlic ~= 0 % Constraints
    fcn = ['[f,df] = ' nlp.probName '_nlicf(' argList ');'];
    eval(fcn);
    InlConstr = f;
    InlConstrGrad = df*squeeze(nlp.B(:,:,1));
end

%% Integral Cost & Path Constraint Functions
% =========================================
if nlp.ntcf ~= 0 % Costs
    [nTraj,nCoeff,nbps] = size(nlp.B);
    argList = sprintf('z(%d,:),',[1:nTraj]);
    argList = argList(1:end-1);
    fcn = ['[f,df] = ' nlp.probName '_tcf(' argList ');'];
    eval(fcn);
    trajOBJ = trapz(nlp.bps,f,2);
    V1 = repmat(df,[nCoeff 1]).*reshape(nlp.B,[nCoeff*nTraj nbps]);
    V2 = reshape(trapz(nlp.bps,V1'),[nTraj nCoeff]);
    trajOBJGrad = sum(V2,1);
end


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

%% Final Cost & Constraint Functions
% =================================
argList = sprintf('%f,',z(:,end)); argList = argList(1:end-1);
if nlp.nfcf ~= 0 % Costs
    fcn = ['[f,df] = ' nlp.probName '_fcf(' argList ');'];
    eval(fcn);
    FObj = f; 
    FObjGrad = df'*nlp.B(:,:,end);
end

if nlp.nnlfc ~= 0 % Constraints
    fcn = ['[f,df] = ' nlp.probName '_nlfcf(' argList ');'];
    eval(fcn);
    FnlConstr = f;
    FnlConstrGrad =  df'*squeeze(nlp.B(:,:,end));
end

if isempty(nlp.LinCon.A)
    linConstr = [];
else
    linConstr = nlp.LinCon.A*x;
end

Obj = IObj + trajOBJ + FObj;
nlConstr = [InlConstr;TnlConstr;FnlConstr;GnlConstr];

if isempty(IObjGrad)
    IObjGrad = zeros(1,nlp.nIC);
end

if isempty(trajOBJGrad)
    trajOBJGrad = zeros(1,nlp.nIC);
end

if isempty(FObjGrad)
    FObjGrad = zeros(1,nlp.nIC);
end

ObjGrad = IObjGrad + trajOBJGrad + FObjGrad;
nlConstrGrad = [InlConstrGrad;TnlConstrGrad;FnlConstrGrad;GnlConstrGrad];


F = [Obj;
    linConstr;
    nlConstr;
    ];

G = full([ObjGrad; nlp.LinCon.A; nlConstrGrad]);


