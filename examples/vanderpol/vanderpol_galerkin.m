%                    VANDERPOL OSCILLATOR
%                    --------------------
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
x = traj(1,4,5);
u = traj(2,3,5);


% Create derivatives of trajectory variables
% ==========================================
xd = deriv(x); 
xdd = deriv(xd);


% Define constraints
% ==================
Constr = constraint(1,'x',1,'initial')  + ... % Linear Initial
    constraint(0,'xd',0,'initial') + ... % Linear Initial
    constraint(1,'-x + xd',1,'final') + ...   % Linear Final
    constraint(0,'xdd + x - (1-x^2)*xd-u',0,'galerkin');


% Define Cost Function
% ====================
Cost = cost('0.5*(x^2 + xd^2 + u^2)','trajectory'); % Minimise state and control

% Collocation Points, use Chebyshev Gauss Lobatto collocation points.
% ===================================================================
HL = nodesCGL(0,5,10);

% Path where the problem related files will be stored
% ===================================================
pathName = './'; % Directory where code is generated.

% Name of the problem, will be used to identify files
% ===================================================
probName = 'vanSim';

% List of trajectories used in the problem
% ========================================
TrajList = trajList(x,xd,xdd,u);

% =========================================================================
% ParamList contains information about constants that might be used in the
% problem. For this problem, there are none.
% For usage information, see brachistochrone example.
% =========================================================================
ParamList = [];

nlp = ocp2nlp(TrajList, Cost,Constr, HL, ParamList,pathName,probName);
x0 = linspace(0,10,nlp.nIC)';
xlow = -Inf*ones(nlp.nIC,1);
xupp = Inf*ones(nlp.nIC,1);

silent = true; % Do not print iteration information from fmincon.
[x,fval,exitflag,output] = optragenSolve(x0,xlow,xupp,silent);

disp(output.message);
fprintf(1,'Optimal Cost: %.6f\n', fval);

sp = getTrajSplines(nlp,x);
zSP = sp{1};
zdSP = fnder(zSP);
zddSP = fnder(zdSP);
uSP = sp{2};

refinedTimeGrid = linspace(min(HL),max(HL),100);
z = fnval(zSP,refinedTimeGrid);
zd = fnval(zdSP,refinedTimeGrid);
zdd = fnval(zddSP,refinedTimeGrid);
u = fnval(uSP,refinedTimeGrid);
u1 = zdd + z - (1-z.^2).*zd;

figure(1);clf;
subplot(2,2,1);plot(refinedTimeGrid,z,'Linewidth',1); xlabel('Time');ylabel('x');
subplot(2,2,2);plot(refinedTimeGrid,zd,'Linewidth',1); xlabel('Time'); ylabel('xd');
subplot(2,2,3);plot(refinedTimeGrid,zdd,'Linewidth',1); xlabel('Time');ylabel('xdd');
subplot(2,2,4);plot(refinedTimeGrid,u,'b',refinedTimeGrid,u1,'r--');xlabel('Time');ylabel('u,u_flat');
legend([{'Galerkin'},{'Diff Flat'}]); 
