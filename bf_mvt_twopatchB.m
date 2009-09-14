% bruteforce search best patch residents time for two patch types

close all;
clear all;
more off;


PATCH = [50 100];
PN = 2;

TAU = [10 50 100 500 1000 5000 10000 50000 100000 500000];
TN = 10;

prt = zeros(PN, TN);
maxRate = zeros(PN, TN);
collected = zeros(PN, TN);

patchA = load(sprintf('avgGainFct_%d.dat', PATCH(1) ) );
patchB = load(sprintf('avgGainFct_%d.dat', PATCH(2) ) );

[M N] = size(patchA.g);
time = 0.1:0.1:N/10;

maxRate = zeros(1,TN);

STEPSIZE = 10;

for a = 1:STEPSIZE:N
  fprintf('processing prtA %f\n', a);

  for b = 1:STEPSIZE:N
    for t = 1:TN
      rate = ( patchA.g(a) + patchB.g(b) ) / ( time(a) + time(b) + 2*TAU(t) );

      if (rate > maxRate(t) )
        maxRate(t) = rate;
        prtA(t) = time(a);
        prtB(t) = time(b);
        collected(t) = patchA.g(b) + patchB.g(b);
      end

    end % for t
  end % for b
end % a

filename = sprintf('bf_mvt_two_%d_%d.dat',PATCH(1), PATCH(2));
save(filename, "maxRate", "prtA", "prtB", "collected");