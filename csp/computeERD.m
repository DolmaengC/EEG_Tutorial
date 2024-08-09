function erd = computeERD(baseline, task)
    % computeERD: baseline과 task 구간에서의 전력 변화를 사용하여 ERD 계산
    % baseline: baseline 구간 데이터 (channels x samples)
    % task: task 구간 데이터 (channels x samples)
    % erd: ERD 값 (channels x 1)
    
    power_baseline = mean(baseline .^ 2, 2); % baseline 전력
    power_task = mean(task .^ 2, 2); % task 전력
    
    erd = ((power_baseline - power_task) ./ power_baseline) * 100;
end
