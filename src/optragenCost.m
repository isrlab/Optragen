% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
function [F, G] = optragenCost(x)
global nlp;

z = getTrajValues(nlp.B,x);

% Initialize Cost Variables
% ==========================
IObj = 0; IObjGrad = [];
trajOBJ = 0; trajOBJGrad = [];
FObj = 0; FObjGrad = [];

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

%% Integral Cost
% ==============
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

%% Final Cost
% ===========
argList = sprintf('%f,',z(:,end)); argList = argList(1:end-1);
if nlp.nfcf ~= 0 % Costs
    fcn = ['[f,df] = ' nlp.probName '_fcf(' argList ');'];
    eval(fcn);
    FObj = f; 
    FObjGrad = df'*nlp.B(:,:,end);
end

Obj = IObj + trajOBJ + FObj;
F = Obj;

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

G = [];
if nargout > 1
    G = full(ObjGrad);
end

