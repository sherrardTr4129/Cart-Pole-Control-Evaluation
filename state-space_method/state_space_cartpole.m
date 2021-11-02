clc
clear all

syms l M m x x_dot t t_dot g x_ddot t_ddot
syms dl_dt1 dl_dt2 dl_dt1_dot dl_dt2_dot
syms jac dDL_dtDdt1 dDL_dtDdt2



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

eqn1 = dDL_dtDdt1 - dl_dt1;
eqn2 = dDL_dtDdt2 - dl_dt2 ;

% Solving for angular accelaration of both Links

sol = solve([eqn1 == 0, eqn2 == 0],[x_ddot,t_ddot]);



% Defining the State Space of the System
X = sym('X',[4,1]);
X(1) = x;
X(2) = t;
X(3) = x_dot;
X(4) = t_dot;

% Solving Differential Eqn using ODE45
[t,X] = ode45(@ode_two_link,[0 10],[10,5,0,0]);

subplot(2,2,1)
plot(t,X(:,1))
title("Trajectory of Cart")
xlabel("Time (s)")
ylabel("Angle (Rad)")
subplot(2,2,2)
plot(t,X(:,2))
title("Trajectory of Pole")
xlabel("Time (s)")
ylabel("Angle (Rad)")
subplot(2,2,3)
plot(t,X(:,3))
title("Velocity of Cart")
xlabel("Time (s)")
ylabel("Velocity (Rad/s)")
subplot(2,2,4)
plot(t,X(:,4))
title("Velocity of Pole")
xlabel("Time (s)")
ylabel("Velocity (Rad/s)")

%%
function dx = ode_two_link(t,x) % ODE45 function modelled after demo provided in class
    m = 1; M = 1;
    l = 1;
    g = 9.81;
    
    dx = zeros(4,1);
    x = num2cell(x);
    [x,t,x_dot,t_dot] = deal(x{:});
    
    % Preventing wraping of theta
    if abs(t)>2*pi
        t = mod(t,2*pi);
    end
    
   
    
    F1 = 0;
    F2 = 0;
    
    dx(1) = x_dot;
    dx(2) = t_dot;
    % dz(3) and dz(4) are t1_ddot and t2_ddot obtained from solving
    dx(3) = (m*sin(t)*(- l*t_dot^2 + g*cos(t)))/(- m*cos(t)^2 + M + m);
    dx(4) = (sin(t)*(- l*m*cos(t)*t_dot^2 + M*g + g*m))/(l*(- m*cos(t)^2 + M + m));


end