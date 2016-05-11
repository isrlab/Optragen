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

%nlpp('clear');

% Create trajectory variables
% ===========================
z = traj(1,4,5);


% Create derivatives of trajectory variables
% ==========================================
zd = deriv(z); zdd = deriv(zd);


% Define constraints
% ==================
Constr = constraint(1,'z',1,'initial')  + ... % Linear Initial
    constraint(0,'zd',0,'initial') + ... % Linear Initial
    constraint(1,'-z + zd',1,'final');   % Linear Final


% Define Cost Function
% ====================
Cost = cost('0.5*(z^2 + zd^2 + (zdd + z - (1-z^2)*zd)^2)','trajectory'); % Minimise state and control

% Collocation Points, use Chebyshev Gauss Lobatto collocation points.
% ===================================================================
HL = nodesCGL(0,5,10);

% =============================================
% Use NPSOL to solve the resulting NLPP,
% right now this is the only supported solver
% =============================================

% Path where the problem related files will be stored
% ===================================================
pathName = './'; % Directory where code is generated.

% Name of the problem, will be used to identify files
% ===================================================
probName = 'vanSim';

% List of trajectories used in the problem
% ========================================
TrajList = trajList(z,zd,zdd);

% =========================================================================
% ParamList contains information about constants that might be used in the
% problem. For this problem, there are none.
% For usage information, see brachistochrone example.
% =========================================================================
ParamList = [];

nlp = ocp2nlp(TrajList, Cost,Constr, HL, ParamList,pathName,probName);
init = linspace(0,10,nlp.nIC);
snset('Minimize');
xlow = -Inf*ones(nlp.nIC,1);
xupp = Inf*ones(nlp.nIC,1);
tic;
[x,F,inform] = snopt(init',xlow,xupp,[0;nlp.LinCon.lb;nlp.nlb],[Inf;nlp.LinCon.ub;nlp.nub],'ocp2nlp_cost_and_constraint');
toc;
F(1)
sp = getTrajSplines(nlp,x);
zSP = sp{1};
zdSP = fnder(zSP);
zddSP = fnder(zdSP);

refinedTimeGrid = linspace(min(HL),max(HL),100);
z = fnval(zSP,refinedTimeGrid);
zd = fnval(zdSP,refinedTimeGrid);
zdd = fnval(zddSP,refinedTimeGrid);

figure(1);clf;
subplot(1,3,1);plot(refinedTimeGrid,z); %xlabel('Time');%title('z');
subplot(1,3,2);plot(refinedTimeGrid,zd); %xlabel('Time');%title('\dot{z}');
subplot(1,3,3);plot(refinedTimeGrid,zdd); %xlabel('Time');%title('\ddot{z}');

