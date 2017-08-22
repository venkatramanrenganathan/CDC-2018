% Venkatraman Renganathan
% W_MSR Code studying the spoofing attack in a stochastic manner
% Input initial conditions of node values
% See the consensus converging despite having F malicious nodes
clear all; close all; clc;
m = 8;
F = 1;
delay = 10;
time_span = 50;
repeats = 100; % Monte-carlo Simulation
repeat_vec = 1:repeats;
mean_x = zeros(repeats, 1);
diff_mean = zeros(repeats, 1);
delay = 4;
spoof_threshold = 0.90;
x_0 = [50 51 52 53 54 55 300 300];
legit_mean_x0 = mean(x_0(1:end-2));
signal_to_noise_ratio = 10;
%%%%%%%%%%%%% Spoofing 1 Node %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:repeats        
    x = spoof_resilient_wmsr(m, F, time_span, delay, spoof_threshold, signal_to_noise_ratio, x_0);
    [x_row,x_col] = size(x);
    if(x_row == 8)
        mean_x(i) = mean(x(1:end-2,end));
    else
        mean_x(i) = mean(x(1:end-1,end));
    end
    diff_mean(i) = mean_x(i) - legit_mean_x0;
end
diff_mean_estimate = mean(diff_mean);    

% Monte-carlo estimate to find probability of attack being detected will
% affect the final consensus. In short, we will find out the estimated
% probability of spoofing attack being detected and mitigated using our
% algorithm.

% figure;
% plot(repeat_vec, diff_mean);
% title('Difference Between MC Estimate & Initial Consensus vs Repetitions');
% xlabel('Spoofing Threshold');
% ylabel('Difference in Consensus Value');
% a = findobj(gcf, 'type', 'axes');
% h = findobj(gcf, 'type', 'line');
% set(h, 'linewidth', 5);
% set(a, 'linewidth', 4);
% set(a, 'FontSize', 24);

figure;
time_vec = 0:1:time_span+1;
plot(time_vec,x);
hold on;
plot(time_vec, legit_mean_x0*ones(1,time_span+2),'-.r');
hold on;
Y1 = max(x_0(1:end-2))*ones(1,time_span+2);
Y2 = min(x_0(1:end-2))*ones(1,time_span+2);
plot(time_vec, Y1, '--b', time_vec, Y2, '--b');
h = fill([time_vec fliplr(time_vec)], [Y1 fliplr(Y2)], 'b');
set(h,'facealpha',0.1);
title('Resilient Consensus using Spoof Resilient W-MSR Algorithm')
xlabel('Time Steps');
ylabel('Information states');
ylim([-20 320]);
legend('Agent 1','Agent 2','Agent 3','Agent 4','Agent 5','Agent 6','Agent 7(Mal)', 'Legitimate Mean');
a = findobj(gcf, 'type', 'axes');
h = findobj(gcf, 'type', 'line');
set(h, 'linewidth', 4);
set(a, 'linewidth', 4);
set(a, 'FontSize', 24);

