function [ F ] = f_obj(x)
%objective function 
F = (x(2)+x(1).^2-11)^2 + (x(1)+x(2)^2-7)^2;
end
