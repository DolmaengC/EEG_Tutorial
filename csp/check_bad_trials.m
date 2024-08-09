function bad_trials = check_bad_trials(data, start_idx, end_idx)
    % 주어진 데이터에서 "bad trial"을 검사합니다.
    % data: 입력 데이터 (channels x samples)
    % start_idx: 검사 시작 인덱스
    % end_idx: 검사 종료 인덱스

    num_trials = size(data, 2);
    bad_trials = false(1, num_trials);
    
    for i = 1:num_trials
        trial_data = data(:, i);
        if end_idx > length(trial_data)
            end_idx = length(trial_data);
        end
        if any(abs(trial_data(start_idx:end_idx)) > 100)
            bad_trials(i) = true;
        end
    end
end
