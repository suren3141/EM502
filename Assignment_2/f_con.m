function [c,ceq] = f_con(x, k)
%Inequality constraint
c = k - x(2)^2 - (x(1)-5)^2;
ceq = [];