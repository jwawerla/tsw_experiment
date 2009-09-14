% use online method to find best patch residents time in random order


close all;
clear all;
more off;

for x = 11:20
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
  a = 0;
  b = 0;

  patch = 1:200;
  % make patch encounter random
  patch = shuffle(patch);

  for i = 1:200

    if patch(i) <= 100
      p = 1;
      j = patch(i);
      a = a + 1;
    else
      p = 2;
      j = patch(i) - 100;
      b = b + 1;
    end

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
              if p == 1
                prtA(a,t) = time;
                collectedA(a, t) = g;
                avgRateA(a, t) = g / ( time + TAU(t) );
              else
                prtB(b,t) = time;
                collectedB(b, t) = g;
                avgRateB(b, t) = g / ( time + TAU(t) );
              end

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


  filename = sprintf('omvt_rnd_%d_%d:%d.dat', PATCH(1), PATCH(2), x);
  save(filename, "prtA", "prtB", "collectedA", "collectedB", "avgRateA", "avgRateB");

end % for x
