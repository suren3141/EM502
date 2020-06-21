function err = square_sum_error(k)
    % k = [a, b, c, d];
    f = k(1).*exp(k(3).*(x+k(2)))+k(4)*x;
    err = sum((y-f).^2);
end