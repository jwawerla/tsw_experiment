% use online method to find best patch residents time for a stepwise
% combination of two patches

close all;
clear all;
more off;

SIM_TIME      = 2;
SUM_COLLECTED = 3;

PATCH = [50 100];

TAU = [10 50 100 500 1000 5000 10000 50000 100000 500000];
TN = 10;

MIN_STAY = 30 /0.1;

TAU_FILT = 0.001;

G = zeros(200, TN);
T = zeros(200, TN);
tt = zeros(200, TN);
gg = zeros(200, TN);

GN = 200;

i = 0;

for p = 1:2
  for j = 1:100
    i = i + 1;
    filename = sprintf('./data/experiment_1_%d:%d.dat', PATCH(p),j );
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

              tt(j,t) = time;
              gg(j,t) = g;

              if i <= GN
                G(i+1, t) = sum(gg(1:i,t));
                T(i+1, t) = sum(tt(1:i,t)) + i * TAU(t);
              else
                G(i+1, t) = sum(gg(i-GN:i),t);
                T(ji+1, t) = sum(tt(i-GN:i,t)) + GN * TAU(t);
              end

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
end % for p

filename = sprintf('omvt_%d_%d.dat', PATCH(1), PATCH(2));
save(filename, "prt", "collected", "avgRate");


