function plotFilteredDataWithBadTrials(data1, data2, events, titleStr, legend1, legend2, bad_trials_left, bad_trials_right)
    % 필터링된 데이터와 "bad trial"을 시각화합니다.
    figure;
    hold on;
    
    % 데이터 플롯
    plot(data1);
    plot(data2, '--');

    % 이벤트 표시
    if ~isempty(events)
        event_indices = find(events == 1);
        for i = 1:length(event_indices)
            xline(event_indices(i), 'g-', 'Event');
        end
    end

    % "bad trial" 표시
    bad_trial_indices_left = find(bad_trials_left);
    bad_trial_indices_right = find(bad_trials_right);
    for i = 1:length(bad_trial_indices_left)
        xline(bad_trial_indices_left(i), 'r--', 'Bad Trial');
    end
    for i = 1:length(bad_trial_indices_right)
        xline(bad_trial_indices_right(i), 'r--', 'Bad Trial');
    end

    xlabel('Time');
    ylabel('Amplitude');
    title(titleStr);
    legend(legend1, legend2, 'Event', 'Bad Trial');
    hold off;
end
