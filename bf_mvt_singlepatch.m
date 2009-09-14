% bruteforce search best patch residents time

close all;
clear all;
more off;


PATCH = [10 30 50 100 200 300];
PN = 6;

TAU = [10 50 100 500 1000 5000 10000 50000 100000 500000];
TN = 10;

prt = zeros(PN, TN);
maxRate = zeros(PN, TN);
collected = zeros(PN, TN);

for p = 1:PN
  filename = sprintf('./avgGainFct_%d.dat', PATCH(p) );
  data = load(filename);
  fprintf('processing %s...\n', filename);
  [M N] = size(data.g);

  for t = 1:TN
    maxRate(p,t) = 0;

    for n = 1:N
      time = n * 0.1;
      rate = data.g(n) / ( time + TAU(t) );

      if (rate > maxRate(p, t) )
        maxRate(p, t) = rate;
        prt(p, t) = time;
        collected(p, t) = data.g(n);
      end

    end % for n
  end % for t
end % p

save("bf_mvt_singlepatch.dat", "maxRate", "prt", "collected");