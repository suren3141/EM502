function z = myeval(f, x, y)
    s = size(x);
    z = zeros(s);
    for i = 1:numel(x)
       z(i) = f([x(i), y(i)]); 
    end
end