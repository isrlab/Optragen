% =======================================================================
%   OCP2NLP
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
clear all;clc;
global nlp V0 g;

ninterv = 2;
hl = 1.0;

% Create trajectory variables
% ===========================
x = traj(ninterv,4,5); % Arguments are ninterv, smoothness, order
y = traj(ninterv,4,5);
tf = traj(1,0,1);

% Create derivatives of trajectory variables
% ==========================================
xd = deriv(x);
yd = deriv(y);

ParamList = {'V0','g'}; % Constants used in the problem
V0 = 0.0; g = 10;

% Define constraints
% ==================
Constr = constraint(0,'x',0,'initial') + ... % x(0)
    constraint(0,'y',0,'initial') + ...   % y(0)
    constraint(0.001,'tf',Inf,'initial') + ...   %
    constraint(1,'x',1,'final') + ...     % x(tf)   Final position, time is normalised
    constraint(1,'y',1,'final') + ...     % y(tf)   Final position, time is normalised
    constraint(0,'(xd^2 + yd^2) - tf^2*(V0^2 + 2*g*y)',0,'trajectory'); % Dynamics as a path constraint

% Define Cost Function
% ====================
Cost = cost('tf','final'); % Minimise time

% Collocation Points, using Gaussian Quadrature formula
% =====================================================
HL = nodesCGL(0,1,10);

% Path where the problem related files will be stored
% ===================================================
pathName = './';  % Save it all in the current directory.

% Name of the problem, will be used to identify files
% ===================================================
probName = 'brachi';

% List of trajectories used in the problem
% ========================================
TrajList = trajList(x,xd,y,yd,tf);

%HL = linspace(0,hl,30);


nlp = ocp2nlp(TrajList, Cost,Constr, HL, ParamList,pathName,probName);

xlow = -Inf*ones(nlp.nIC,1);%xlow(end) = 0.001;
xupp = Inf*ones(nlp.nIC,1);

x0 = ones(1,nlp.nIC)';

silent = true; % Do not print iteration information from fmincon.
[x,fval,exitflag,output] = optragenSolve(x0,xlow,xupp,silent);

disp(output.message);
fprintf(1,'Optimal Cost: %.6f\n', fval);

sp = getTrajSplines(nlp,x);
xSP = sp{1};
ySP = sp{2};
tfSP = sp{3};

refinedTimeGrid = linspace(min(HL),max(HL),100);

X = fnval(xSP,refinedTimeGrid);
Xd = fnval(fnder(xSP),refinedTimeGrid);

Y = fnval(ySP,refinedTimeGrid);
Yd = fnval(fnder(ySP),refinedTimeGrid);

th = atan2(Yd,Xd);

TF = fnval(tfSP,refinedTimeGrid);

C1 = (Xd.^2 + Yd.^2) - (TF.^2).*(V0^2 + 2*g*Y);
figure(1); clf;
subplot(2,2,1);plot(X,-Y); xlabel('x'); ylabel('y');
subplot(2,2,2);plot(refinedTimeGrid,-th); xlabel('Time'); ylabel('\theta');
subplot(2,2,3:4);plot(refinedTimeGrid,C1); xlabel('Time'); ylabel('error');


