function [b, a] = BUTTERWORTH(fc, fs, order)
    % Tạo bộ lọc Butterworth thông thấp đúng cách
    % fc: Tần số cắt
    % fs: Tần số lấy mẫu
    % order: Bậc của bộ lọc
    
    % Chuẩn hóa tần số cắt theo Nyquist
    Wn = fc / (fs/2); 
    
    % Tạo bộ lọc Butterworth số hóa đúng cách
    [b, a] = butter(order, Wn, 'low');

    % Kiểm tra độ ổn định của bộ lọc
    if any(abs(roots(a)) >= 1)
        warning('Bộ lọc Butterworth không ổn định, hãy kiểm tra lại tham số!');
    end
end