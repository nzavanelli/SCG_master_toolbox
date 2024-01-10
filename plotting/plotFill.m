function [h] = plotFill(t,mu,dev,c)
  % [h] = plotFill(t,mu,dev,c)
  % t: time (or whatever)
  % mu: mean to be plotted around
  % dev: deviation +/- around mean to be filled.
  % c: color ([R G B])
  
  % For whatever reason, using row vectors....
  if ~isrow(t)
    t = t';
  end

  if ~isrow(mu)
    mu = mu';
  end

  if ~isrow(dev)
    devH = dev';
    devL = -devH;
  end

  hi = mu + devH;
  lo = mu + devL;

  areaT = [t, fliplr(t)];
  areaY = [lo, fliplr(hi)];

  h = fill(areaT, areaY, c, 'EdgeColor','None');
end
