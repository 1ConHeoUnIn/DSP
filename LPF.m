function h = LPF(fc, fs, N)
    % Tạo bộ lọc FIR thông thấp theo phương pháp hàm sinc
    % fc: Tần số cắt
    % fs: Tần số lấy mẫu
    % N: Bậc của bộ lọc

    % Xác định chỉ số mẫu
    n = -N/2:N/2;
    
    % Hàm sinc
    h = (fc/fs) * sinc(2 * fc/fs * n);
    
    % Áp dụng cửa sổ Hamming để giảm ripples
    w = hamming(length(h))';
    h = h .* w;
    
    % Chuẩn hóa để tổng hệ số bằng 1
    h = h / sum(h);
end