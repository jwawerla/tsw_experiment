% calculate the average gain function for each patch type

close all;
clear all;
more off;

NMAX = 94000;
SIM_TIME      = 2;
SUM_COLLECTED = 3;


PATCH = [10 30 50 100 200 300];
PN = 6;

gg = zeros(100, NMAX);
g = zeros(1, NMAX);

% over all patch types
for p = 1:PN

  % over all instances of a patch type
  for i = 1:100
    filename = sprintf('./data/experiment_1_%d:%d.dat', PATCH(p),i);
    data = load(filename);
    fprintf('processing %s\n', filename);
    [N M] = size(data);
 
    N = min(NMAX, N);

    for n = 1:N
      gg(i,n) = data(n, SUM_COLLECTED);
    end % for n

    for n = N:NMAX
      gg(i,n) = data(N, SUM_COLLECTED);
    end % for n

  end % for i

  for n = 1:NMAX
    g(n) = mean(gg(:,n));
  end % n

  filename = sprintf('avgGainFct_%d.dat', PATCH(p));

  save(filename, "g");

end % for p




