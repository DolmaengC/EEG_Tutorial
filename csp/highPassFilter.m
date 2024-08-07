function filtered_data = highPassFilter(data, fs, order, cutoff)
    % highPassFilter: 데이터에 하이패스 필터를 적용합니다.
    % data: 입력 데이터
    % fs: 샘플링 주파수 (Hz)
    % order: 필터 차수
    % cutoff: 컷오프 주파수 (Hz)
    % filtered_data: 필터링된 데이터

    % 정규화된 컷오프 주파수
    Wn = cutoff / (fs / 2);

    % Butterworth 하이패스 필터 계수 계산
    [b, a] = butter(order, Wn, 'high');

    % 데이터 필터링
    filtered_data = filtfilt(b, a, data);
end

