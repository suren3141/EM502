%% Variable parameters

clear all;
close all;

k = 36; %k value for f_con == k-x(2)^2-(x(1)-5)^2

% Visually estimated local minima and other stationary points
MIN=[-2.8, 3.1; -3.8, -3.2; 3.6, -2; 3, 2];
STAT =[-3, 0; 0, 2.8; -.15, -1; 3.4, 0];

% Initial values
x0 = [1,4];

% Constraint function 
%fun_con = @(x)f_con(x,k);
fun_con = @(x)f_con_new(x);

% Feasbile variable (x1, x2) range
X_min = -6;
Y_min = -6;

% Graph Size
x_min = -6; x_max = 6;
y_min = -6; y_max = 6;

%% Problem Formulation

% Graph parameters
alpha=.5;       % shading region
con_line= 200;  % number of contour lines
%marker_size =  12;   % Marker size
eps=10^-6;

% Graph range
X1 = x_min:.2:x_max;
X2 = y_min:.2:y_max;

[X, Y] = meshgrid(X1, X2);

l1 = length(X1);
l2 = length(X2);

z = myeval(@(x)f_obj(x), X, Y);

z_con = myeval(fun_con, X, Y);

% Feasible X, Y
xp1 = X1; yp1 = 0*xp1 + Y_min;
yp2 = X2; xp2 = 0*yp2 + X_min;

zp1 = myeval(fun_con, xp1, yp1);
zp2 = myeval(fun_con, xp2, yp2);
zp1(zp1<0) = 0;
zp2(zp2<0) = 0;

% Feasible region
syms xx;
syms yy;
f_region = fun_con([xx, yy]);

%% Problem formulation plots

if X_min <=x_min
    x_min_ = X_min-eps;
else
    x_min_ = x_min;
end

if Y_min <=y_min
    y_min_ = Y_min-eps;
else
    y_min_ = y_min;
end

x_fill = [x_min_, x_max, x_max, X_min, X_min, x_min_];
y_fill = [y_min_, y_min_, Y_min, Y_min, y_max, y_max];

%FIG0 - Cons 3D
figure;
hold on
mesh(X, Y, z_con);
mesh(X, Y, zeros(l2, l1));

ez0 = ezplot(f_region, [x_min, x_max]);
set(ez0,'color','k')
plot3(xp1, yp1, zp1, 'k');
plot3(xp2, yp2, zp2, 'k');
hold off


xp0 = ez0.ContourMatrix(1, 2:end);
yp0 = ez0.ContourMatrix(2, 2:end);

fill_ = [xp0', yp0'];
ind_ = fill_(:, 1)>=X_min-.02 & fill_(:,2)>=Y_min;
fill_ = fill_(ind_, :);
if abs(fill_(1,1) - fill_(end, 1)) > 0.0001
    fill_ = [fill_; X_min,Y_min; x_max,Y_min];    
end
x_fill_ = fill_(:, 1)'; y_fill_ = fill_(:, 2)';

zp0 = myeval(@(x)f_obj(x), xp0, yp0);
zp1 = myeval(@(x)f_obj(x), xp1, yp1);
zp2 = myeval(@(x)f_obj(x), xp2, yp2);


%FIG2 - 2D
figure;
hold on
plot(xp0, yp0,  'k', xp1, yp1, 'k', xp2, yp2, 'k', 'LineWidth',1);
h2a = fill(x_fill_, y_fill_, 'k');
set(h2a,'facealpha',alpha)
h2b = fill(x_fill, y_fill, 'k');
set(h2b,'facealpha',alpha)
hold off

%FIG1 - 3D
figure;
hold on
mesh(X, Y, z);
plot3(xp0, yp0, zp0, 'k', xp1, yp1, zp1, 'k', xp2, yp2, zp2, 'k', 'LineWidth',1.5, 'LineStyle','--');
hold off

%FIG3 - 2D
figure;
hold on
plot(xp0, yp0,  'k', xp1, yp1, 'k', xp2, yp2, 'k', 'LineWidth',1.5, 'LineStyle','--');
contour(X1, X2, z, con_line)

h3a = fill(x_fill_, y_fill_, 'k');
set(h3a,'facealpha',alpha)
h3b = fill(x_fill, y_fill, 'k');
set(h3b,'facealpha',alpha)

scatter(MIN(:,1), MIN(:,2), 'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','r');
scatter(STAT(:,1), STAT(:,2), 'd', 'MarkerEdgeColor','k', 'MarkerFaceColor','g');

hold off


%%

% AX <= b
A = [];
b = [];

% AeqX = beq
Aeq = [];
beq = [];

% lb < X < ub
lb = [X_min, Y_min];
ub = [];

% Initial values
%x0 = [0,0];
%x0 = [0,2];
%x0 = [-2,-2];

% options = optimoptions('fmincon','Display','iter');%,'Algorithm','sqp');
[x_ans, fval, history, exitflag, output, lambda, grad, hessian] = myoptim(@f_obj, x0, A, b, Aeq, beq, lb, ub, fun_con);

disp(x_ans);
disp(fval);

%% HISTORY

history = [x0; history];
f_history = myeval(@(x)f_obj(x), history(:, 1), history(:, 2)); 
x_hist = history(1:end-1, 1);
y_hist = history(1:end-1, 2);
u_hist = history(2:end, 1) - x_hist;
v_hist = history(2:end, 2) - y_hist;

%% PLOT

%FIG4 - 3D
figure;
hold on;
mesh(X, Y, z);
plot3(xp0, yp0, zp0, 'k', xp1, yp1, zp1, 'k', xp2, yp2, zp2, 'k', 'LineWidth',1.5, 'LineStyle','--');
scatter3(history(:, 1), history(:, 2), f_history(:), 'MarkerEdgeColor','k', 'MarkerFaceColor','r');
scatter3(x_ans(1), x_ans(2), fval, 'MarkerEdgeColor','k', 'MarkerFaceColor','b');
hold off


%FIG5 - 2D
figure;
hold on;
plot(xp0, yp0, 'k')
plot(xp1, yp1, 'k')
plot(xp2, yp2, 'k')
contour(X1, X2, z, con_line)

h5a = fill(x_fill_, y_fill_, 'k');
set(h5a,'facealpha',alpha)
h5b = fill(x_fill, y_fill, 'k');
set(h5b,'facealpha',alpha)

quiver(x_hist, y_hist, u_hist, v_hist,0, 'Color','k', 'LineWidth', 1, 'MaxHeadSize',.1);
scatter(history(:, 1), history(:, 2), 'MarkerEdgeColor','k', 'MarkerFaceColor','r');
scatter(x_ans(1), x_ans(2),'MarkerEdgeColor','k', 'MarkerFaceColor','b');
scatter(x0(1), x0(2),'MarkerEdgeColor','k', 'MarkerFaceColor','g');


hold off
