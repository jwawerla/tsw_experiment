close all;
clear all;

avg = load('avgGainFct_50.dat');

[M N] = size(avg.g);


% maxiaml time
MAX_TIME = 4000;
N = min(MAX_TIME * 10, N);

% patch swichting time [s]
TAU = 1000;

% times
time = 0.1:0.1:N*0.1;
tangentTime = -TAU:0.1:N*0.1;

% MVT theoretical optimal patch residents time [s]
RT = 956.7;

% number of pucks in a patch
NP = 50;

lamda = 0.001352;

% theoretical gain function
g = NP * (1 - exp(-lamda * time) );


% gradiant at optimal residents time
m = NP * lamda * exp(-lamda * RT);

% tangent
y = m * tangentTime + TAU * m;

% line
lx(1) = RT;
ly(1) = 0;
lx(2) = RT;
ly(2) = NP * (1 - exp(-lamda * RT));

figure(1);
plot(time, avg.g(1:N), 'b-');
hold on;
plot(time, g, 'g-');
plot(tangentTime, y, 'r-');
plot(lx, ly, 'k-.');
hold off;
grid on;
xlabel('t [s]', 'fontsize', 14);
ylabel('pucks', 'fontsize', 14);
axis([-TAU MAX_TIME 0 52]);

%print('mvtTangent.eps', '-depsc');

j = 0;
for i = 1:10:N
  j = j + 1;
  avgG(j) = avg.g(i);
  G(j) = g(i);
end

fd = fopen('mvtTangent1.dat', 'wt');
fprintf(fd, '%f\n', avgG);
fclose(fd);

fd = fopen('mvtTangent2.dat', 'wt');
fprintf(fd, '%f\n', g);
fclose(fd);