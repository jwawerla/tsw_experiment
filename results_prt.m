close all;
clear all;
more off;

TAU = [10 50 100 500 1000 5000 10000 50000 100000 500000];
TN = 10;

PATCH = [10 30 50 100 200 300];
PN = 6;


%-------------------------------------------------------------------------------
% compare bf with online for single patches
%------------------------------------------------------------------------------

% Load and preprocess data
bf = load('bf_mvt_singlepatch.dat');

for p = 1:PN
  om = load(sprintf('omvt_%d.dat', PATCH(p)) );  
  for t = 1:TN
    omPrt(p,t) = mean(om.prt(:,t));
    fprintf('%3d %6d : %f %f \n', PATCH(p), TAU(t), bf.prt(p,t),
                                  mean(om.prt(:,t)));
  end % for t
end % for p

% plot
for p = 1:PN
  figure;
  loglog(TAU, bf.prt(p,:), 'r-o;bf;' );
  hold on;
  loglog(TAU, omPrt(p,:), 'g-+;online;');
  hold off;
  xlabel('\tau [s]', 'fontsize', 14);
  ylabel('residents time [s]', 'fontsize', 14);
  grid on;
  print(sprintf('singlepatch_prt_%d.eps', PATCH(p)), '-depsc');
end % for p


%-------------------------------------------------------------------------------
% compare bf with online for two patch stepwise change
%-------------------------------------------------------------------------------
for s = 1:2

  if s == 1
    PATCH = [50 100];
  else
    PATCH = [50 300];
  end

  bf  = load(sprintf('bf_mvt_two_%d_%d.dat', PATCH(1), PATCH(2) ) );
  omA = load(sprintf('omvt_%d_%d.dat', PATCH(1), PATCH(2) ) );
  omB = load(sprintf('omvt_%d_%d.dat', PATCH(2), PATCH(1) ) );

  for t = 1:TN
    bfPrt(t) = bf.prtA(t) + bf.prtB(t);
    omPrtA(t) = mean(omA.prt(:,t));
    omPrtB(t) = mean(omB.prt(:,t));
  end % for t

  figure;
  loglog(TAU, bfPrt, 'r-o;bf;');
  hold on;
  loglog(TAU, omPrtA, sprintf('g-+;%d -> %d;', PATCH(1), PATCH(2) ) );
  loglog(TAU, omPrtB, sprintf('b-*;%d -> %d;', PATCH(2), PATCH(1) ) );
  hold off;
  xlabel('\tau [s]', 'fontsize', 14);
  ylabel('residents time [s]', 'fontsize', 14);
  grid on;
  print(sprintf('twopatch_step_%d_%d.eps', PATCH(1), PATCH(2)), '-depsc');
end % for s
