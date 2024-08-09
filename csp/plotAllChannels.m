function plotAllChannels(data1, data2, events, titleText, ylabel1, ylabel2)
    figure;
    for channel = 1:64
        subplot(8, 8, channel);
        plot(data1(channel, :));
        hold on;
        plot(data2(channel, :));
        if ~isempty(events)
            for event = events
                xline(event, '--r');
            end
        end
        title(sprintf('Channel %d', channel));
        ylabel(ylabel1);
        xlabel(ylabel2);
    end
    sgtitle(titleText);
end
