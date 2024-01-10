function [x_avg] = avg_beat_ewma(beats,lambda)


nbeats = size(beats,2);
len = size(beats,1);
nans = NaN * ones(len,1);

% INITIAL CONDITIONS
w(1) = 1;
x{1} = beats(:,1);
% x_avg_prev{1} = nans;
% x_avg{1} = beats(:,1);
x_avg_prev(:,1) = nans;
x_avg(:,1) = beats(:,1);

% RECURSIVE AVERAGING
for N = 2:nbeats
    w(N) = lambda * w(N-1) + 1;
    
    x{N} = beats(:,N);
%     x_avg_prev{N} = x_avg{N-1};
%     x_avg{N} = (1 - 1./w(N))*x_avg_prev{N} + (1./w(N))*x{N};

    x_avg_prev(:,N) = x_avg(:,N-1);
    x_avg(:,N) = (1 - 1./w(N))*x_avg_prev(:,N) + (1./w(N))*x{N};
end

end