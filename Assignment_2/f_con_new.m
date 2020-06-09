function [c,ceq] = f_con_new(x)
%Inequality constraint
%k = 26;
c = 13 - x(2)^2 - x(1)^2;

ceq = [];