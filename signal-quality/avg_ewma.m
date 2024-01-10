function [X_ewma] = avg_ewma(X,lambda)


len = length(X);

% INITIAL CONDITIONS
w(1) = 1;
x(1) = X(1);
x_avg_prev(1) = NaN;
x_avg(1) = X(1);

% RECURSIVE AVERAGING
for N = 2:len
    w(N) = lambda * w(N-1) + 1;
    
    x(N) = X(N);
    x_avg_prev(N) = x_avg(N-1);
    x_avg(N) = (1 - 1./w(N))*x_avg_prev(N) + (1./w(N))*x(N);
    
end

X_ewma = x_avg;

end