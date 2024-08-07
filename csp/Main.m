% EEGLAB 설치 여부 확인 및 초기화
if exist('eeglab', 'file')
    eeglab;
else
    error('EEGLAB is not installed. Please install EEGLAB to proceed.');
end

% topoplot 함수 확인
if ~exist('topoplot', 'file')
    error('topoplot function is not available. Please check EEGLAB installation.');
end

% 채널 위치 정보 로드
EEG = pop_chanedit(EEG, 'lookup', fullfile(fileparts(which('eeglab')), 'plugins', 'dipfit', 'standard_BESA', 'standard-10-5-cap385.elp'));

% 파일 이름 설정
fileName = '../LRHandMI/s01.mat';

% EEGData 객체 생성
eeg_data = EEGData(fileName);

% 파일 읽기
eeg_data = eeg_data.readFile();

% 필요한 경우 chanlocs 필드 추가
eeg_data.chanlocs = EEG.chanlocs;

% 데이터 전처리: Centering and Scaling
eeg_data.imagery_left = preprocessData(eeg_data.imagery_left);
eeg_data.imagery_right = preprocessData(eeg_data.imagery_right);

% 밴드패스 필터링 (8-30 Hz)
filtered_imagery_left = bandPassFilter(eeg_data.imagery_left, eeg_data.srate, 4, 8, 30);
filtered_imagery_right = bandPassFilter(eeg_data.imagery_right, eeg_data.srate, 4, 8, 30);

% 시간 구간 설정 (500ms 간격)
time_intervals = [500, 1000, 1500, 2000]; % ms

% ERD 계산
erd_left = [];
erd_right = [];

for t = time_intervals
    start_idx = round((t + 2000) / 1000 * eeg_data.srate); % baseline 시작 인덱스
    end_idx = round((t + 2500) / 1000 * eeg_data.srate); % baseline 종료 인덱스

    % baseline 데이터 추출 (-2000ms to 0ms)
    baseline_left = filtered_imagery_left(:, start_idx:end_idx);
    baseline_right = filtered_imagery_right(:, start_idx:end_idx);

    % task 데이터 추출 (0ms to 2000ms)
    task_left = filtered_imagery_left(:, end_idx:(end_idx + eeg_data.srate * 2));
    task_right = filtered_imagery_right(:, end_idx:(end_idx + eeg_data.srate * 2));

    % ERD 계산
    erd_left(:, end+1) = computeERD(baseline_left, task_left);
    erd_right(:, end+1) = computeERD(baseline_right, task_right);
end

% Topographic Map 그리기 (EEGLAB 필요)
figure;
for i = 1:length(time_intervals)
    subplot(2, length(time_intervals), i);
    topoplot(erd_left(:, i), eeg_data.chanlocs);
    title(['L ' num2str(time_intervals(i)) ' ms']);
    colorbar;

    subplot(2, length(time_intervals), i + length(time_intervals));
    topoplot(erd_right(:, i), eeg_data.chanlocs);
    title(['R ' num2str(time_intervals(i)) ' ms']);
    colorbar;
end
