close all;
clear all;
more off;


SIM_TIME      = 2;
SUM_COLLECTED = 3;

PATCH = [10 30 50 100 200 300];
PN = 6;

for p = 1:PN

  for i = 1:100
    filename = sprintf('./data/experiment_1_%d:%d.dat', PATCH(p),i );
    data = load(filename);
    %fprintf('processing %s ...\n', filename);
    [N M] = size(data);

    time(p,i) = N / 10;

  end % for i
  
  avgTime(p) = mean(time(p,:));
  stdTime(p) = std(time(p,:));
  maxTime(p) = max(time(p,:));
  minTime(p) = min(time(p,:));

  fprintf('%3d  mean %f std %f min %f max %f \n', PATCH(p), avgTime(p),
            stdTime(p), minTime(p), maxTime(p) );
end % for p

save exhaustive_foragingtimes.dat avgTime, stdTime, maxTime minTime
