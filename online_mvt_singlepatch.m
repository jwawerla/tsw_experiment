% use online method to find best patch residents time

close all;
clear all;
more off;

SIM_TIME      = 2;
SUM_COLLECTED = 3;

PATCH = [10 30 50 100 200 300];
PN = 6;

TAU = [10 50 100 500 1000 5000 10000 50000 100000 500000];
TN = 10;

MIN_STAY = 30 /0.1;

TAU_FILT = 0.002;

for p = 1:PN

  G = zeros(100, TN);
  T = zeros(100, TN);

  for i = 1:100
    filename = sprintf('./data/experiment_1_%d:%d.dat', PATCH(p),i );
    data = load(filename);
    fprintf('processing %s ...\n', filename);
    [N M] = size(data);

    count = zeros(1,TN);
    done = zeros(1,TN);
  
    R = zeros(N, TN);
    Rfilt = zeros(N, TN);

    for n = 1:N
      time = data(n, SIM_TIME);
      g = data(n, SUM_COLLECTED);

      for t = 1:TN

        R(n,t) = (g + G(i, t)) / ( time + TAU(t) + T(i, t) );

        if (n == 1)
          Rfilt(n,t) = R(n,t);
        else
          Rfilt(n,t) = Rfilt(n-1,t) + TAU_FILT * ( R(n,t) - Rfilt(n-1,t) );

          if (Rfilt(n, t) < Rfilt(n-1, t)) && (n > MIN_STAY)
            count(t) = count(t) + 1;
            if (count(t) > 100) && (done(t) == 0)
              prt(i,t) = time;
              collected(i, t) = g;
              avgRate(i, t) = g / ( time + TAU(t) );
              G(i+1, t) = G(i,t) + g;
              T(i+1, t) = T(i,t) + time + TAU(t);
              done(t) = 1;
            end
          else
            count(t) = 0;
        end 

        end % if (n == 1)
      end % for t

      if (sum(done) == TN)
        break;
      end

    end % for n
  end % for i

  filename = sprintf('omvt1_%d.dat', PATCH(p));
  save(filename, "prt", "collected", "avgRate");
end % p

