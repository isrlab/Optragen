function [x,fval,exitflag,output] = optragenSolve(x0,xlow,xupp,silent)
global nlp

if silent
    silentStr = 'none';
else
    silentStr = 'iter';
end

options = optimoptions('fmincon', 'Display',silentStr,'Algorithm','interior-point');
%                                      'SpecifyObjectiveGradient',false, ...
%                                      'SpecifyConstraintGradient',false);
                                 

% Construct linear inequality constraint
[A,b,Aeq,beq] = optragenLinConstr;

xlow = -Inf*ones(nlp.nIC,1);
xupp = Inf*ones(nlp.nIC,1);

[x,fval,exitflag,output] = fmincon(@optragenCost, x0, A, b, Aeq, beq, xlow, xupp, @optragenConstraint,options);    