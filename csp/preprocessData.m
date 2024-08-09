function data = preprocessData(data)
    % preprocessData: 데이터를 Centering 및 Scaling 합니다.
    % data: 입력 데이터 (channels x samples)
    % data: 전처리된 데이터

    % Centering: 각 채널의 평균을 0으로 맞춤
    data = data - mean(data, 2);

    % Scaling: 각 채널의 표준편차를 1로 맞춤
    data = data ./ std(data, 0, 2);
end
