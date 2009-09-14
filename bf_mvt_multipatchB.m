% bruteforce search best patch residents time for four patch types

close all;
clear all;
more off;


PATCH = [50 100 200 300];
PN = 4;

TAU = [10 50 100 500 1000 5000 10000 50000 100000 500000];
TN = 10;

prt = zeros(PN, TN);
maxRate = zeros(PN, TN);
collected = zeros(PN, TN);

patchA = load(sprintf('avgGainFct_%d.dat', PATCH(1) ) );
patchB = load(sprintf('avgGainFct_%d.dat', PATCH(2) ) );
patchC = load(sprintf('avgGainFct_%d.dat', PATCH(3) ) );
patchD = load(sprintf('avgGainFct_%d.dat', PATCH(4) ) );

[M N] = size(patchA.g);
N = 50000;
time = 0.1:0.1:N/10;

maxRate = zeros(1,TN);

STEPSIZE = 333;

for a = 25000:STEPSIZE:N
  for b = 1:STEPSIZE:N
    fprintf('processing prtA %f  prtB %f \n', a, b);
    for c = 1:STEPSIZE:N
      for d = 1:STEPSIZE:N

        for t = 1:TN
          gSum = patchA.g(a) + patchB.g(b) + patchC.g(c) + patchD.g(d);
          tSum = time(a) + time(b) +  time(c) + time(d);
          rate = gSum / ( tSum  + PN*TAU(t) );

          if (rate > maxRate(t) )
            maxRate(t) = rate;
            prtA(t) = time(a);
            prtB(t) = time(b);
            prtC(t) = time(c);
            prtD(t) = time(d);
            collected(t) = gSum;
          end

        end % for t
      end % for d
    end % for c
  end % for b
end % for a

filename = sprintf('bf_mvt_multiB_%d_%d_%d_%d.dat',PATCH(1), PATCH(2), PATCH(3), PATCH(4));
save(filename, "maxRate", "prtA", "prtB", "prtC", "prtD", "collected");