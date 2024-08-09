function plotData(data1, data2, events, titleStr, legend1, legend2)
    % 데이터를 시각화
    figure;
    hold on;
    
    % 데이터 플롯
    plot(data1);
    plot(data2);

    % 이벤트 표시
    if ~isempty(events)
        event_indices = find(events == 1);
        for i = 1:length(event_indices)
            xline(event_indices(i), 'g-', 'Event');
        end
    end

    xlabel('Time');
    ylabel('Amplitude');
    title(titleStr);
    if ~isempty(events)
        legend(legend1, legend2, 'Event');
    else
        legend(legend1, legend2);
    end
    hold off;
end
