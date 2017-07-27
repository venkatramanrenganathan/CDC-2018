% Venkatraman Renganathan
% W_MSR Code tackling the spoofing attack
% Input initial conditions of node values
% See the consensus converging despite having F malicious nodes
clear all; close all; clc;
m = 8;
F = 1;
spoof_count = 1;
time_span = 50;
delay_vec = 0:15;

%%%%%%%%%%%%% Spoofing 1 Node %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for index = 1:length(delay_vec) 
    delay = delay_vec(index);
    x_0 = [50 51 52 300 54 55 56 300];
    mean_x_0 = mean(x_0);
    x = wmsr_modified(m, F, spoof_count, time_span, delay, x_0);
    error(index) = (abs(x(1,50) - x(7,50)))/mean_x_0 * 100;
end

m = 9;
F = 1;
spoof_count = 2;
time_span = 50;

%%%%%%%%%%%%% Spoofing 2 Nodes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for index = 1:length(delay_vec) 
    delay = delay_vec(index);
    x_0 = [50 51 52 300 54 55 56 300 300];
    mean_x_0 = mean(x_0);
    x = multiple_spoofing_wmsr(m, F, spoof_count, time_span, delay, x_0);
    error_1(index) = (abs(x(1,50) - x(7,50)))/mean_x_0 * 100;
end

error = error / 2;
error_1 = error_1 / 2;

time_vec = 0:15;
plot(time_vec, error, 'r', time_vec, error_1, 'b');
title('% Error Between Malicious & Consensus Values vs Delay');
xlabel('Delay in Time Steps');
ylabel('% Error');
legend('Spoofing 1 Node', 'Spoofing 2 Nodes')
a = findobj(gcf, 'type', 'axes');
h = findobj(gcf, 'type', 'line');
set(h, 'linewidth', 5);
set(a, 'linewidth', 4);
set(a, 'FontSize', 24);
axis tight