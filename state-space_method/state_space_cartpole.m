clc
clear all

syms l M m x x_dot t t_dot g x_ddot t_ddot
syms dl_dt1 dl_dt2 dl_dt1_dot dl_dt2_dot
syms jac dDL_dtDdt1 dDL_dtDdt2
syms F1 F2

m = 1; M = 1;
l = 1;
g = 9.81;


% Findning Lagrangian of System
L = (1/2)*(M+m)*x_dot^2 + 0.5*m*l^2*t_dot^2-m*l*cos(t)*t_dot*x_dot - m*g*l*cos(t) ;

%Solving for all Partial Differential
jac = jacobian(L,[x,x_dot,t,t_dot]);
dl_dt1 = jac(1,1); 
dl_dt1_dot = jac(1,2);
dl_dt2 = jac(1,3);
dl_dt2_dot = jac(1,4);

% Finding Time Derivative for Euler-Lagrangian Equation
dDL_dtDdt1 = jacobian(dl_dt1_dot,[x;x_dot;t;t_dot])*[x_dot;x_ddot;t_dot;t_ddot];
dDL_dtDdt2 = jacobian(dl_dt2_dot,[x;x_dot;t;t_dot])*[x_dot;x_ddot;t_dot;t_ddot];

eqn1 = dDL_dtDdt1 - dl_dt1 - F1 ;
eqn2 = dDL_dtDdt2 - dl_dt2 - F2 ;

% Solving for angular accelaration of both Links

sol = solve([eqn1 == 0, eqn2 == 0],[x_ddot,t_ddot]);



% Defining the State Space of the System
X = sym('X',[4,1]);
X(1) = x;
X(2) = t;
X(3) = x_dot;
X(4) = t_dot;

X_dot = sym('X_dot',[4,1]);
X_dot(1) = X(3);
X_dot(2) = X(4);
X_dot(3) = sol.x_ddot;
X_dot(4) = sol.t_ddot;

syms u

u = F1;


% Linearization

A = double(subs(jacobian(X_dot,X),{x,x_dot,t,t_dot,F1,F2},{0,0,0,0,0,0}));
B = double(subs(jacobian(X_dot,u),{x,x_dot,t,t_dot,F1,F2},{0,0,0,0,0,0}));



% Controllability
rankC0 = rank(ctrb(A,B));

% State Feedback controller for eigenvalues of -2,- 3, -2+2i,-2-2i
lambda = [-2,-3,-2+2i,-2-2i]; % Desired Eigenvalues

Kn = acker(A,B,lambda);

init = [0;5*pi/180;0;0];

 

% % Solving Differential Eqn using ODE45
% [t,X] = ode45(@ode_two_link,[0 10],[2,deg2rad(30),0,0]);
% 
% subplot(2,2,1)
% plot(t,X(:,1))
% title("Trajectory of Cart")
% xlabel("Time (s)")
% ylabel("Angle (Rad)")
% subplot(2,2,2)
% plot(t,X(:,2))
% title("Trajectory of Pole")
% xlabel("Time (s)")
% ylabel("Angle (Rad)")
% subplot(2,2,3)
% plot(t,X(:,3))
% title("Velocity of Cart")
% xlabel("Time (s)")
% ylabel("Velocity (Rad/s)")
% subplot(2,2,4)
% plot(t,X(:,4))
% title("Velocity of Pole")
% xlabel("Time (s)")
% ylabel("Velocity (Rad/s)")
% 
% F = -Kn*X';
% u1 = F(1,:);
% u2 = F(2,:);
% 
% figure();
% subplot(2,1,1)
% plot(t,u1);
% title("Input Force of Joint 1")
% ylabel("Force (N)")
% xlabel("Time (s)")
% subplot(2,1,2)
% plot(t,u2)
% title("Input Force of Joint 2")
% ylabel("Force (N)")
% xlabel("Time (s)")
% 
% %%
% function dx = ode_two_link(t,x) 
%     m = 1; M = 1;
%     l = 1;
%     g = 9.81;
%     
%     dx = zeros(4,1);
%     x = num2cell(x);
%     [x,t,x_dot,t_dot] = deal(x{:});
%     
%     % Preventing wraping of theta
%     if abs(t)>2*pi
%         t = mod(t,2*pi);
%     end
% 
%     kn = [15.9377132645288	 5.88408454419913	8.03114336773732	5.05795772789307
%           7.93944486755966	-3.86709192638502	4.03027756622197	5.02854596318886];
%     
% 
%        
% 
%     X = [x x_dot t t_dot]' ;
%     
%     F = -kn*X;
%     F1 = F(1);
%     F2 = F(2);
%     
%     
%     
%     dx(1) = x_dot;
%     dx(2) = t_dot;
%     % dz(3) and dz(4) are t1_ddot and t2_ddot obtained from solving
%     dx(3) = -(- 100*sin(t)*t_dot^2 + 100*F1 + 981*cos(t)*sin(t) + 100*F2*cos(t))/(100*(cos(t)^2 - 2));
%     dx(4) = -(- 50*cos(t)*sin(t)*t_dot^2 + 100*F2 + 981*sin(t) + 50*F1*cos(t))/(50*(cos(t)^2 - 2));
% 
% 
% end