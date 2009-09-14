close all;
clear all;
more off;

TAU = [10 50 100 500 1000 5000 10000 50000 100000 500000];
TN = 10;

PATCH = [10 30 50 100 200 300];
PN = 6;

TAUVAR_PERCENT = [0.1 0.5 0.7];
TVN = 3;

FONTSIZE = 24;

%-------------------------------------------------------------------------------
% compare bf with online for single patches
%------------------------------------------------------------------------------

% Load and preprocess data
bf = load('bf_mvt_singlepatch.dat');

for p = 1:PN
  om = load(sprintf('omvt_%d.dat', PATCH(p)) );  
  for t = 1:TN
    omRate(p,t) = mean(om.collected(:,t)) / (mean(om.prt(:,t)) + TAU(t));
    percent(p,t) = omRate(p,t)/ bf.maxRate(p,t);
    fprintf('%3d %6d : %f %f => %f \n', PATCH(p), TAU(t), bf.maxRate(p,t),
                                         omRate(p,t), percent(p,t));
  end % for t
  fprintf('avg performance for patch type %d: %f \n', PATCH(p),
                                         mean(percent(p,:)) );
end % for p

% plot
for p = 1:PN
  figure;
  h1 = loglog(TAU, bf.maxRate(p,:), 'r-o;bf;' );
  hold on;
  h2 = loglog(TAU, omRate(p,:), 'g-+;online;');
  hold off;
  set(h1(1), "linewidth", 2)
  set(h2(1), "linewidth", 2)
  %xlabel('\tau [s]', 'fontsize', FONTSIZE);
  %ylabel('rate [pucks/s]', 'fontsize', FONTSIZE);
  grid on;
  print(sprintf('singlepatch_rate_%d.eps', PATCH(p)), '-F:24', '-depsc');
end % for p


%-------------------------------------------------------------------------------
% compare bf with online for single patches and variable tau
%------------------------------------------------------------------------------

% Load and preprocess data
bf = load('bf_mvt_singlepatch.dat');

TAUMEAN = 1000;
TNUM = 5; 

for p = 1:PN
  om = load(sprintf('omvt_tauvar_%d.dat', TAUMEAN) );  
  for tv = 1:TVN

    percent = om.rate(p,tv)/ bf.maxRate(p,TNUM);
    tauVar = TAUMEAN * TAUVAR_PERCENT(tv);

    fprintf('%3d tau var %d: bf %f omvt %f => %f\n', PATCH(p), tauVar, bf.maxRate(p, TNUM),  om.rate(p,tv), percent);
  end % for tv
end % for p




%-------------------------------------------------------------------------------
% compare bf with online for two patches with stepwise change
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
    omRateA(t) = mean(omA.collected(:,t)) / (mean(omA.prt(:,t)) + TAU(t));
    omRateB(t) = mean(omB.collected(:,t)) / (mean(omB.prt(:,t)) + TAU(t));
  end % for t

  figure;
  h1 = loglog(TAU, bf.maxRate, 'r-o;bf;');
  hold on;
  h2 = loglog(TAU, omRateA, sprintf('g-+;%d -> %d;', PATCH(1), PATCH(2) ) );
  h3 = loglog(TAU, omRateB, sprintf('b-*;%d -> %d;', PATCH(2), PATCH(1) ) );
  hold off;
  %xlabel('\tau [s]', 'fontsize', FONTSIZE);
  %ylabel('rate [pucks/s]', 'fontsize', FONTSIZE);
  set(h1(1), "linewidth", 2)
  set(h2(1), "linewidth", 2)
  set(h3(1), "linewidth", 2)
  grid on;
  print(sprintf('twopatch_step_rate_%d_%d.eps', PATCH(1), PATCH(2)), '-F:24', '-depsc');
end % for s


%-------------------------------------------------------------------------------
% compare bf with online for two patches with random  change
%-------------------------------------------------------------------------------
for s = 1:2

  if s == 1
    PATCH = [50 100];
  else
    PATCH = [50 300];
  end

  bf  = load(sprintf('bf_mvt_two_%d_%d.dat', PATCH(1), PATCH(2) ) );
  for i = 1:20
    om = load(sprintf('omvt_rnd_%d_%d:%d.dat', PATCH(1), PATCH(2), i ) );

    for t = 1:TN
      omRAB(t,i) = (mean(om.collectedA(:,t)) + mean(om.collectedB(:,t)))/ ... 
                 (mean(om.prtA(:,t)) + mean(om.prtB(:,t)) + 2 * TAU(t));      
    end % for t
  end % for i

  for t = 1:TN
    omRateAB(t) = mean(omRAB(t,:));
    omRateStd(t) = std(omRAB(t,:));
  end % for t

  figure;
  h1 = loglog(TAU, bf.maxRate, 'r-o;bf;');
  hold on;
  h2 = loglog(TAU, omRateAB, sprintf('g-+; rnd %d %d;', PATCH(1), PATCH(2) ) );
  %h2 = loglogerr(TAU, omRateAB, omRateStd );
  hold off;
  %xlabel('\tau [s]', 'fontsize', FONTSIZE);
  %ylabel('rate [pucks/s]', 'fontsize', FONTSIZE);
  set(h1(1), "linewidth", 2)
  set(h2(1), "linewidth", 2)
 
  grid on;
  print(sprintf('twopatch_rnd_rate_%d_%d.eps', PATCH(1), PATCH(2)), '-F:24', '-depsc');
end % for s

%-------------------------------------------------------------------------------
% compare bf with online for 4 patches 50:100:200:300
%-------------------------------------------------------------------------------
bf  = load('bf_mvt_multi_50_100_200_300.dat');

omA = load('omvt_multi_300_200_100_50.dat');
strA = '300:200:100:50';

omB = load('omvt_multi_50_100_200_300.dat');
strB = '50:100:200:300';
filename = '50_100_200_300';


for t = 1:TN
  omRA(t) = mean(omA.gg(:,t) ) / ( mean(omA.tt(:,t) ) + TAU(t) );
  omRB(t) = mean(omB.gg(:,t) ) / ( mean(omB.tt(:,t) ) + TAU(t) );
end % for t

figure;
h1 = loglog(TAU, bf.maxRate, 'r-o;bf;');
hold on;
h2 = loglog(TAU, omRA, sprintf('g-+; %s;', strA ) );
h3 = loglog(TAU, omRB, sprintf('b-+; %s;', strB ) );
hold off;
%xlabel('\tau [s]', 'fontsize', FONTSIZE);
%ylabel('rate [pucks/s]', 'fontsize', FONTSIZE);
set(h1(1), "linewidth", 2)
set(h2(1), "linewidth", 2)
set(h3(1), "linewidth", 2)
 
grid on;
print(sprintf('multipatch_rate_%s.eps', filename), '-F:24', '-depsc');


%-------------------------------------------------------------------------------
% compare bf with online for 4 patches 50:300:100:200
%-------------------------------------------------------------------------------
bf  = load('bf_mvt_multi_50_100_200_300.dat');

om = load('omvt_multi_50_300_100_200.dat');
str = '50:300:100:200';
filename = '50_300_100_200';


for t = 1:TN
  omR(t) = mean(om.gg(:,t) ) / ( mean(om.tt(:,t) ) + TAU(t) );
end % for t

figure;
h1 = loglog(TAU, bf.maxRate, 'r-o;bf;');
hold on;
h2 = loglog(TAU, omR, sprintf('g-+; %s;', str ) );
hold off;
%xlabel('\tau [s]', 'fontsize', FONTSIZE);
%ylabel('rate [pucks/s]', 'fontsize', FONTSIZE);
set(h1(1), "linewidth", 2)
set(h2(1), "linewidth", 2)
set(h3(1), "linewidth", 2)
 
grid on;
print(sprintf('multipatch_rate_%s.eps', filename), '-F:24', '-depsc');
