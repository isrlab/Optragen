%                    Bang Bang Control
%                    -----------------
%	Example to demonstrate fixed final time problems using NLPP.
%   This problem exploits differential flatness in the system.

% =======================================================================
%   OPTRAGEN
%   Copyright (c) 2005 by
%   Raktim Bhattacharya, (raktim@aero.tamu.edu)
%   Department of Aerospace Engineering
%   Texas A&M University.
%   All right reserved.
% =======================================================================
clear all;

global nlp

% Create trajectory variables
% ===========================
z = traj(2,2,3);
tf = traj(1,0,1);

% Create derivatives of trajectory variables
% ==========================================
zd = deriv(z); zdd = deriv(zd);


% Define constraints
% ==================
Constr = constraint(0,'z',0,'initial')  + ... % Linear Initial
    constraint(1,'z',1,'final') + ...
    constraint(0,'zd',0,'initial') + ...
    constraint(0,'zd',0,'final') + ...
    constraint(0.001,'tf',Inf,'initial') + ...
    constraint(-1,'zdd/tf^2',1,'trajectory');


% Define Cost Function
% ====================
Cost = cost('tf','final'); % Minimise state and control

% Collocation Points, use Chebyshev Gauss Lobatto collocation points.
% ===================================================================
HL = nodesCGL(0,1,10);

% =============================================
% Use NPSOL to solve the resulting NLPP,
% right now this is the only supported solver
% =============================================

% Path where the problem related files will be stored
% ===================================================
pathName = './'; % Directory where code is generated.

% Name of the problem, will be used to identify files
% ===================================================
probName = 'bangbang';

% List of trajectories used in the problem
% ========================================
TrajList = trajList(z,zd,zdd,tf);

% =========================================================================
% ParamList contains information about constants that might be used in the
% problem. For this problem, there are none.
% For usage information, see brachistochrone example.
% =========================================================================
ParamList = [];

nlp = ocp2nlp(TrajList, Cost,Constr, HL, ParamList,pathName,probName);
x0 = linspace(0,10,nlp.nIC)';

xlow = -Inf*ones(nlp.nIC,1); xlow(end) = 0; % For tf
xupp = Inf*ones(nlp.nIC,1);

silent = true; % Do not print iteration information from fmincon.
[x,fval,exitflag,output] = optragenSolve(x0,xlow,xupp,silent);
disp(output.message);
fprintf(1,'Optimal Cost: %.6f\n', fval);

sp = getTrajSplines(nlp,x);
zSP = sp{1};
zdSP = fnder(zSP);
zddSP = fnder(zdSP);

tfSP = sp{2};

refinedTimeGrid = linspace(min(HL),max(HL),100);
z = fnval(zSP,refinedTimeGrid);
zd = fnval(zdSP,refinedTimeGrid);
zdd = fnval(zddSP,refinedTimeGrid);
tf = fnval(tfSP,refinedTimeGrid);

figure(2);clf;
subplot(1,3,1);plot(refinedTimeGrid,z,'Linewidth',1); xlabel('Time'); title('$z$','Interpreter','latex');
subplot(1,3,2);plot(refinedTimeGrid,zd./tf,'Linewidth',1); xlabel('Time'); title('$\dot{z}$','Interpreter','latex');
subplot(1,3,3);plot(refinedTimeGrid,zdd./tf.^2,'Linewidth',1); xlabel('Time'); title('$\ddot{z}$','Interpreter','latex');

