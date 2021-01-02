function [A,b,Aeq,beq] = optragenLinConstr
global nlp

% Construct linear inequality constraint


ii = find(nlp.LinCon.lb ==  nlp.LinCon.ub);
jj = find(nlp.LinCon.lb ~=  nlp.LinCon.ub);

Aeq = full(nlp.LinCon.A(ii,:));
beq = full(nlp.LinCon.lb(ii,:));


A = full([nlp.LinCon.A(jj,:);-nlp.LinCon.A(jj,:)]);
b = full([nlp.LinCon.ub(jj,:);-nlp.LinCon.lb(jj,:)]);

if isempty(A) A = []; end
if isempty(b) b = []; end
