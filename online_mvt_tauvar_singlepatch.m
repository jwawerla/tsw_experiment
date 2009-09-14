close all;
clear all;
more off;

SUM_COL = 3;

PATCH = [10 30 50 100 200 300];
PN = 6;

TAU = 1000;
TAUVAR_PERCENT = [0.1 0.5 0.7];
TVN = 3;

GN = 100;
TAUFILT = 0.001;
tauEst = TAU;

for p = 1:PN
  for tv = 1:TVN
     tauVar = TAU * TAUVAR_PERCENT(tv);
     tau = abs(normrnd( TAU, tauVar, 1, 100) );
     fprintf('tau mean %f std %f \n', mean(tau), std(tau));
     
     G = zeros(100,1);
     T = zeros(100,1);
     gg = zeros(100,1);
     tt = zeros(100,1);
     for i = 1:100
       filename = sprintf('./data/experiment_1_%d:%d.dat', PATCH(p),i );
       data = load(filename);
       fprintf('processing %s ...\n', filename);

       [prt, col] = onlineRateMax(data(:,SUM_COL),G(i),T(i), TAUFILT, tauEst);  

       gg(i) = col;
       tt(i) = prt;
       if i <= GN
         G(i+1) = sum(gg(1:i));
         T(i+1) = sum(tt(1:i)) + i * tau(i);
       else
         G(i+1) = sum(gg(i-GN:i));
         T(i+1) = sum(tt(i-GN:i)) + GN * tau(i);
       end
       tauEst = tauEst + 0.5 * (tau(i) - tauEst);
     end % for i

     rate(p, tv) = mean(gg) / (mean(tt) + mean(tau));
     collected(p, tv) = mean(gg);
     residentsTime(p, tv) = mean(tt);
     swtime(p, tv) = mean(tau);
  end % for tv
end % for p