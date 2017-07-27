clear all; close all; clc;
dt = 0.001; %or sample rate = 1/dt (Hz)
tMax = 10;
t = (0 : dt : tMax)';
norm_max_xcorr_mag = @(x,y)(max(abs(xcorr(x,y)))/(norm(x,2)*norm(y,2)));
x = randn(length(t), 1);
%y = randn(length(t), 1);
y = [zeros(4,1); 3.*x(1:length(t)-4,:)];
% adding white noise
y = awgn(y,tMax,'measured');
signal_similarity = norm_max_xcorr_mag(x,y)
figure(8)
plot(t, x, t, y)
set(gca, 'XLim', [0, 0.04])
grid on
xlabel('Time (s)')
ylabel('Signal (units)')
set(gca, 'XLim', [0, 0.04])
a = findobj(gcf, 'type', 'axes');
h = findobj(gcf, 'type', 'line');
set(h, 'linewidth', 4);
set(a, 'linewidth', 4);
set(a, 'FontSize', 24);

