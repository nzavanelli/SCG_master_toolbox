function [u] = get_unit_vector(v)
%%% * Compute unit vector
% IN
%     - v : MxN vector (M = # samples, N = # channels)
% OUT
%     - u : MxN unit vector

vsq = v.^2;
vssq = sum(vsq,2);
vnorm = sqrt(vssq);
u = v ./ vnorm;

end