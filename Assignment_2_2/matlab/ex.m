load('data.mat')

t = 50;

% k = [a, b, c, d];
F = @(k,x)k(1).*exp(k(3).*(x+k(2)))+k(4)*x;
L = @(k,x,y)sum((y-F(k,x)).^2);

k = (rand(t, 4) - .5)*10;

k0_ = [];
k_lsq_ = [];
k_unc_ = [];
k_src_ = [];
L_k = [];

for i = 1:t
    try
        k0 = k(i, :) * 1;
        L_k0 = L(k0, x, y);
        disp(L_k0)

        % lsqcurvefit
        %opts = optimset('Display','off');
        [k_lsq, L_lsq,~,exitflag,output] = lsqcurvefit(F,k0,x,y);

        % fminunc
        opts = optimoptions('fminunc','Algorithm','quasi-newton');
        [k_unc,L_unc, eflag, output_unc] = fminunc(@(k)L(k, x, y),k0, opts);

        % fminsearch
        [k_src,L_src] = fminsearch(@(k)L(k, x, y),k0);

        k0_ = [k0_; k0];
        k_lsq_ = [k_lsq_; k_lsq];
        k_unc_ = [k_unc_; k_unc];
        k_src_ = [k_src_; k_src];
        L_k = [L_k; L_k0, L_lsq L_unc L_src];
    catch
    end    
end

%%

mn, ind = min(L_k(:));
r = fix((ind-1)/4)+1;
c = mod(ind-1, 4);

if c == 0
    k_ans = k0(r)
elseif c == 1
    k_ans = k0(r)
    
        
end

k_ans = 

figure;
hold on;
scatter(x, y);
plot(x, f(
plot(L_k(:, 2));
plot(L_k(:, 3));
plot(L_k(:, 4));
legend('lsq', 'unc', 'src');
hold off;
%[m, ind] = min(L_k);
