% use online method to find best patch residents time in random order


close all;
clear all;
more off;

SUM_COL = 3;

%PATCH = [50 100 200 300];
%PATCH = [300 200 100 50];
PATCH = [50 300 100 200];
PN = 4;

TAU = [10 50 100 500 1000 5000 10000 50000 100000 500000];
TN = 10;


TAUFILT = 0.001;

G = zeros(100*PN, TN);
T = zeros(100*PN, TN);
tt = zeros(100*PN, TN);
gg = zeros(100*PN, TN);

GN = 400;
i = 0;

for p = 1:PN

  for j = 1:100
    i = i + 1;
    filename = sprintf('./data/experiment_1_%d:%d.dat', PATCH(p),j );
    data = load(filename);
    fprintf('processing %s ...\n', filename);

    for t = 1:TN   

      [prt, col] = onlineRateMax(data(:,SUM_COL), G(i,t), T(i,t), TAUFILT, TAU(t));  

      gg(i,t) = col;
      tt(i,t) = prt;
      if i <= GN
        G(i+1, t) = sum(gg(1:i,t));
        T(i+1, t) = sum(tt(1:i,t)) + i * TAU(t);
      else
        G(i+1, t) = sum(gg(i-GN:i),t);
        T(i+1, t) = sum(tt(i-GN:i,t)) + GN * TAU(t);
      end

    end % for t

  end % for j
end % for p


patchStr = '';
for p = 1:PN
  patchStr = strcat(patchStr, sprintf('_%d', PATCH(p)));
end

filename = sprintf('omvt_multi%s.dat', patchStr);
 save(filename, "gg", "tt");


