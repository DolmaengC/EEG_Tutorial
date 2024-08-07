% 파일 이름 설정
fileName = '../LRHandMI/s01.mat';

% EEGData 객체 생성
eeg_data = EEGData(fileName);

% 파일 읽기
eeg_data = eeg_data.readFile();

% 원시 데이터 시각화 (이벤트 표시 X)
plotData(eeg_data.imagery_left(50, :), eeg_data.imagery_right(13, :), ...
         0, ...
         'Raw Imagery Left (Channel 50) and Right (Channel 13)', ...
         'Raw Imagery Left (Channel 50)', 'Raw Imagery Right (Channel 13)');


% 밴드패스 필터링 (8-30 Hz) - 전체 데이터 필터링
filtered_imagery_left = bandPassFilter(eeg_data.imagery_left, eeg_data.srate, 4, 8, 14);
filtered_imagery_right = bandPassFilter(eeg_data.imagery_right, eeg_data.srate, 4, 8, 14);

% 데이터 전처리: Centering and Scaling
preprocessed_imagery_left = preprocessData(filtered_imagery_left);
preprocessed_imagery_right = preprocessData(filtered_imagery_right);

% 500-2500ms 구간 설정
frame_start = eeg_data.frame(1); % -2000 ms
frame_end = eeg_data.frame(2); % 5000 ms
start_idx = round((500 - frame_start) / 1000 * eeg_data.srate); % 500 ms 기준점 보정
end_idx = round((2500 - frame_start) / 1000 * eeg_data.srate); % 2500 ms 기준점 보정

% "bad trial" 검사 및 표시
bad_trials_left = check_bad_trials(preprocessed_imagery_left, start_idx, end_idx);
bad_trials_right = check_bad_trials(preprocessed_imagery_right, start_idx, end_idx);

% "bad trial"을 제외한 데이터 선택
valid_trials_left = ~bad_trials_left;
valid_trials_right = ~bad_trials_right;

% 유효한 트라이얼의 데이터만 사용
filtered_left = preprocessed_imagery_left(:, valid_trials_left);
filtered_right = preprocessed_imagery_right(:, valid_trials_right);
events_left = eeg_data.imagery_event(valid_trials_left);
events_right = eeg_data.imagery_event(valid_trials_right);

% 필터링 데이터 시각화 (이벤트 표시 X)
plotData(filtered_left(50, :), filtered_right(13, :), ...
         0, ...
         'Filtered Imagery Left (Channel 50) and Right (Channel 13)', ...
         'Filtered Imagery Left (Channel 50)', 'Filtered Imagery Right (Channel 13)');

% CSP 적용
data1 = filtered_left;
data2 = filtered_right;

% 데이터를 동일한 행렬 크기로 맞추기 (전체 데이터 사용)
events = eeg_data.imagery_event(valid_trials_left | valid_trials_right);

% CSP 계산
[W, A] = csp(data1, data2);

% 변환 후 데이터
transformed_data1 = W * data1;
transformed_data2 = W * data2;


% 변환 후 데이터 시각화 (이벤트 표시 포함)
plotData(transformed_data1(50, :), transformed_data2(13, :), events, ...
         'Transformed Data Using CSP (First 3 seconds)', ...
         'Transformed Imagery Left (Channel 50)', ...
         'Transformed Imagery Right (Channel 13)');



% N초 구간 선택
duration = 10; % seconds
num_samples = duration * eeg_data.srate;

transformed_data1 = transformed_data1(:, 1:num_samples);
transformed_data2 = transformed_data2(:, 1:num_samples);

% 변환 후 데이터 시각화 (이벤트 표시 포함)
plotData(transformed_data1(50, :), transformed_data2(13, :), events(1:num_samples), ...
         'Transformed Data Using CSP (First 3 seconds)', ...
         'Transformed Imagery Left (Channel 50)', ...
         'Transformed Imagery Right (Channel 13)');
