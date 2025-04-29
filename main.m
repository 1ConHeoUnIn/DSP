clc; clear; close all;

%% 1. Khởi tạo thông số
fs = 1000; % Tần số lấy mẫu (Hz)
fc = 100;  % Tần số cắt (Hz)
N = 50;    % Bậc của FIR
order = 4; % Bậc của Butterworth
t = 0:1/fs:1; % Thời gian mẫu

%% 2. Tạo tín hiệu đầu vào (có nhiễu)
x_clean = sin(2*pi*50*t) + sin(2*pi*300*t); % Tín hiệu tổng hợp
noise = 0.5 * randn(size(t));  % Nhiễu trắng Gaussian
x = x_clean + noise; % Tín hiệu bị nhiễu cần lọc

%% 3. Thiết kế bộ lọc FIR LPF (hàm sinc)
h_fir = LPF(fc, fs, N);
y_fir = filter(h_fir, 1, x);

%% 4. Thiết kế bộ lọc Butterworth LPF
[b_but, a_but] = BUTTERWORTH(fc, fs, order);
y_but = filter(b_but, a_but, x);

%% 5. Phân tích tần số bộ lọc
[H_fir, W_fir] = freqz(h_fir, 1, 1024, fs);
[H_but, W_but] = freqz(b_but, a_but, 1024, fs);



%% 6. Hiển thị kết quả
figure;

% (1) Tín hiệu đầu vào
subplot(3,2,1);
plot(t, x, 'k');
title('Tín hiệu đầu vào (có nhiễu)');
xlabel('Thời gian (s)');
ylabel('Biên độ');

% (2) Đáp ứng tần số của FIR LPF
subplot(3,2,2);
plot(W_fir, abs(H_fir));
title('Đáp ứng tần số của FIR LPF');
xlabel('Tần số (Hz)');
ylabel('Biên độ');

% (3) Tín hiệu sau khi lọc bằng FIR
subplot(3,2,3);
plot(t, y_fir, 'b');
title('Tín hiệu sau khi lọc bằng FIR');
xlabel('Thời gian (s)');
ylabel('Biên độ');

% (4) Đáp ứng tần số của Butterworth LPF
subplot(3,2,4);
plot(W_but, abs(H_but));
title('Đáp ứng tần số của Butterworth LPF');
xlabel('Tần số (Hz)');
ylabel('Biên độ');

% (5) Tín hiệu sau khi lọc bằng Butterworth
subplot(3,2,5);
plot(t, y_but, 'r');
title('Tín hiệu sau khi lọc bằng Butterworth');
xlabel('Thời gian (s)');
ylabel('Biên độ');

sgtitle('So sánh Bộ lọc FIR & Butterworth');

%% 7. Hiển thị cực-zero của bộ lọc
figure;
subplot(1,2,1);
zplane(h_fir, 1);
title('Cực-Zero của FIR LPF');

subplot(1,2,2);
zplane(b_but, a_but);
title('Cực-Zero của Butterworth LPF');

%% 8. Đáp ứng xung (500 điểm đầu của h[n])

figure;

% --- FIR Impulse Response ---
subplot(2,1,1);
% The impulse response of an FIR filter is its coefficients h_fir.
% The length of h_fir is N+1 (51 in this case).
% The LPF function calculates it symmetrically around n=0, from -N/2 to N/2.
n_fir = -N/2 : N/2; % Create the correct time index vector for FIR (-25 to 25)
stem(n_fir, h_fir, 'b'); % Plot h_fir against the correct indices n
title('Đáp ứng xung của FIR LPF');
xlabel('n');
ylabel('h[n]');
xlim([min(n_fir)-1 max(n_fir)+1]); % Adjust x-axis limits slightly

% --- Butterworth Impulse Response ---
subplot(2,1,2);
num_points_impz = 500; % Number of points to calculate for IIR response
impulse_response = impz(b_but, a_but, num_points_impz);
% impz calculates the response starting from n=0.
n_but = 0 : num_points_impz - 1; % Create the time index vector (0 to 499)
stem(n_but, impulse_response, 'r'); % Plot the calculated response against n
title('Đáp ứng xung của Butterworth LPF');
xlabel('n');
ylabel('h[n]');
xlim([-1 num_points_impz]); % Adjust x-axis limits slightly

sgtitle('Đáp ứng xung của Bộ lọc LPF');
