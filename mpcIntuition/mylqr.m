function [y, t, x, delta] = mylqr(veh, Ux, tMax, e0)

t = linspace(0, tMax, 1000);

Cf = veh.Cf;
Cr = veh.Cr;
a = veh.a;
b = veh.b;
Iz = veh.Iz;
kp = veh.kLK;
L = veh.L;
xLA = veh.xLA;
m = veh.m;
Kug = veh.FzF/Cf - veh.FzR/Cr;
g = 9.81;
Gffw = (L+Kug*Ux^2/g);

%Define state matrices - state is e, dPsi, r, beta, control input is 
%now delta. 

A33 = (-a^2*Cf - b^2*Cr) / (Ux*Iz); 
A34 = (b*Cr - a*Cf)/Iz; 
A43 = (b*Cr - a*Cf)/(m*Ux^2) - 1;
A44 = -(Cf+Cr)/(m*Ux); 

A = [0 Ux 0 Ux; 0 0 1 0; 0 0 A33 A34; 0 0 A43 A44];
B = [0 0 a*Cf/Iz Cf/(m*Ux)]';
C = [1 0 0 0];
D = 0; 

sys = ss(A, B, C, D);

sys = ss(A, B, C, D);
N = 0; 
Q = eye(4);
R = 1000;

[K,S,e] = lqr(sys, Q, R, N);

Acl = A - B*K;
Bcl = zeros(4,1);
Ccl = [1 0 0 0];
Dcl = 0;

sysCL = ss(Acl, Bcl, Ccl, Dcl);

u = zeros(size(t)); %no curvature, we are simulating a straight line
x0 = [e0; 0; 0; 0];

[y,t,x] = lsim(sysCL, u, t, x0);

delta = -K*x';
delta = delta';

end