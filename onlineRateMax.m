function [prt, collected] = onlineRateMax(data, G, T, tauFilt, switchingTime)

  COUNT = 100;
  MIN_STAY =  300;

  [N M] = size(data);

  R = zeros(1,N);
  Rfilt = zeros(1,N);
  count = 0;
  n = 0;

  while (count < COUNT)
    n = n + 1;
    time = 0.1 * n;
    if (n <= N)
      g = data(n);
    end

    R(n) = (g + G) / ( time + switchingTime + T );

    if (n > 1)
      Rfilt(n) = Rfilt(n-1) + tauFilt * ( R(n) - Rfilt(n-1) );

      if (Rfilt(n) - Rfilt(n-1) <= 0) && (n > MIN_STAY)
        count = count + 1;
      else
        count = 0;
      end
    else
      Rfilt(n) = R(n);
    end

  end % while

  prt = time;
  collected = g;
