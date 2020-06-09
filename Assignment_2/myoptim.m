function [x, fval, history, exitflag, output, lambda, grad, hessian] = myoptim(f_obj, x0, A, b, Aeq, beq, lb, ub, f_con)
    history = []; % Get intermediate values.
    options = optimoptions('fmincon','Display','iter', 'OutputFcn', @myoutput, 'Algorithm','sqp');
    %options = optimset('OutputFcn', @myoutput);
    [x,fval,exitflag,output,lambda,grad,hessian] = fmincon(f_obj, x0, A, b, Aeq, beq, lb, ub, f_con, options);
        
    function stop = myoutput(x,optimvalues,state)
        stop = false;
        if isequal(state,'iter')
          history = [history; x];
        end
    end
end
