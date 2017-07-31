clear all; close all; clc;
dt = 0.001; 
tMax = 10;
t = (0 : dt : tMax)';
norm_max_xcorr_mag = @(x,y)(max(abs(xcorr(x,y)))/(norm(x,2)*norm(y,2)));
x = randn(length(t), 1);
y1 = randn(length(t), 1);
% Spoofed neighbor fingerprint looks like delayed and amplified fingerprint
% of legitimate neighbor x. That is, x spoofs y2
y2 = [zeros(4,1); 3.*x(1:length(t)-4,:)];
% adding white noise - tmax is the signal to noise ratio - can be varied to
% get different similarities
y1 = awgn(y1,tMax,'measured');
y2 = awgn(y2,tMax,'measured');
disp('Signal similarity between two legitimate neighbor fingerprints')
signal_similarity_1 = norm_max_xcorr_mag(x,y1)
disp('Signal similarity between a legitimate and spoofed neighbor fingerprints')
signal_similarity_2 = norm_max_xcorr_mag(x,y2)
figure(8)
plot(t, x, t, y1, t, y2)
set(gca, 'XLim', [0, 0.04])
grid on
xlabel('Time (s)')
ylabel('Signal (units)')
legend('Legitimate Neighbor 1', 'Legitimate Neighbor 2', 'Spoofed Neighbor')
set(gca, 'XLim', [0, 0.04])
a = findobj(gcf, 'type', 'axes');
h = findobj(gcf, 'type', 'line');
set(h, 'linewidth', 4);
set(a, 'linewidth', 4);
set(a, 'FontSize', 24);

