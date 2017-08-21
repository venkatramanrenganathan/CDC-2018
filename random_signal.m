% This matlab code is for simulating similarities between 2 random signals
clear all; close all; clc;
dt = 0.001; 
tMax = 10;
t = (0 : dt : tMax)';
norm_max_xcorr_mag = @(x,y)(max(abs(xcorr(x,y)))/(norm(x,2)*norm(y,2)));
y1 = randn(length(t), 1);
% Spoofed neighbor fingerprint looks like delayed and amplified fingerprint
% of legitimate neighbor x. That is, y1 spoofs y2
y2 = [zeros(4,1); 3.*y1(1:length(t)-4,:)];
% adding white noise
signal_noise_ratio = 10;
y1 = awgn(y1,signal_noise_ratio,'measured');
y2 = awgn(y2,signal_noise_ratio,'measured');
disp('Signal similarity between a legitimate and spoofed neighbor fingerprints')
signal_similarity = norm_max_xcorr_mag(y1,y2)
figure;
plot(t, y1, t, y2)
grid on
xlabel('Time (s)')
ylabel('Signal (units)')
legend('Legitimate Neighbor', 'Spoofed Neighbor');
a = findobj(gcf, 'type', 'axes');
h = findobj(gcf, 'type', 'line');
set(h, 'linewidth', 4);
set(a, 'linewidth', 4);
set(a, 'FontSize', 24);

