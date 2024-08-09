import numpy as np
import scipy.io
from scipy.signal import butter, lfilter

# Bandpass 필터 함수
def butter_bandpass(lowcut, highcut, fs, order=5):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = butter(order, [low, high], btype='band')
    return b, a

def butter_bandpass_filter(data, lowcut, highcut, fs, order=5):
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = lfilter(b, a, data)
    return y

# trial 분리 함수
def split_trial(data, event, pre_event_samples, post_event_samples):
    splited_data = []
    len_data = data.shape[1]
    for event_sample_idx in event.astype(int):
        start_idx = event_sample_idx - pre_event_samples
        end_idx = event_sample_idx + post_event_samples
        if start_idx < 0:
            continue  # 시작 인덱스가 0보다 작으면 생략
        if end_idx > len_data:
            continue  # 종료 인덱스가 데이터 길이를 넘으면 생략
        epoch = data[:, start_idx:end_idx]
        if epoch.shape[1] == pre_event_samples + post_event_samples:
            splited_data.append(epoch)
    return np.array(splited_data)

# CAR 적용 함수
def apply_car(data):
    mean_signal = np.mean(data, axis=0)
    car_data = data - mean_signal
    return car_data

# Baseline Correction 함수
def baseline_correction(data, srate, pre_event_samples):
    baseline_start_idx = pre_event_samples - int(2 * srate)
    baseline_end_idx = pre_event_samples
    baseline_mean = np.mean(data[:, baseline_start_idx:baseline_end_idx], axis=1, keepdims=True)
    corrected_data = data - baseline_mean
    return corrected_data

# MATLAB 파일 로드
mat_file_path = '../../data/LRHandMI/s02.mat'  # 실제 파일 경로로 수정
mat_data = scipy.io.loadmat(mat_file_path)

# 'eeg' 구조체 추출
eeg = mat_data['eeg']

# 필드 추출
imagery_left = eeg['imagery_left'][0, 0]
imagery_right = eeg['imagery_right'][0, 0]
imagery_event = eeg['imagery_event'][0, 0].flatten()  # 이벤트 정보 추출

# Sampling rate (samples per second)
srate = eeg['srate'][0, 0][0, 0]

# 프레임 길이 설정
pre_event_samples = int(2 * srate)  # 2000ms 이전
post_event_samples = int(5 * srate)  # 5000ms 이후

# 이벤트를 기준으로 데이터 자르기
splited_imagery_left_eeg = split_trial(imagery_left, imagery_event, pre_event_samples, post_event_samples)
splited_imagery_right_eeg = split_trial(imagery_right, imagery_event, pre_event_samples, post_event_samples)

# CAR 및 Baseline Correction 적용
car_imagery_left_eeg = []
car_imagery_right_eeg = []
for i in range(len(splited_imagery_left_eeg)):
    car_data_left = apply_car(splited_imagery_left_eeg[i])
    car_data_right = apply_car(splited_imagery_right_eeg[i])
    corrected_data_left = baseline_correction(car_data_left, srate, pre_event_samples)
    corrected_data_right = baseline_correction(car_data_right, srate, pre_event_samples)
    car_imagery_left_eeg.append(corrected_data_left)
    car_imagery_right_eeg.append(corrected_data_right)

car_imagery_left_eeg = np.array(car_imagery_left_eeg)
car_imagery_right_eeg = np.array(car_imagery_right_eeg)

# Bandpass 필터 적용
def apply_bandpass_filter(data, lowcut, highcut, fs, order=5):
    filtered_data = np.zeros(data.shape)
    for channel in range(data.shape[0]):
        for trial in range(data.shape[1]):
            filtered_data[channel, trial, :] = butter_bandpass_filter(data[channel, trial, :], lowcut, highcut, fs, order)
    return filtered_data

# Bandpass 필터 적용 예제
lowcut = 1.0
highcut = 30.0
order = 3

filtered_car_imagery_left_eeg = apply_bandpass_filter(car_imagery_left_eeg, lowcut, highcut, srate, order)
filtered_car_imagery_right_eeg = apply_bandpass_filter(car_imagery_right_eeg, lowcut, highcut, srate, order)

print(f'Original EEG Data Shape: {np.array(splited_imagery_left_eeg).shape}')
print(f'CAR and Baseline Corrected EEG Data Shape: {car_imagery_left_eeg.shape}')
print(f'Filtered CAR EEG Data Shape: {filtered_car_imagery_left_eeg.shape}')

# 데이터 시각화 함수
import matplotlib.pyplot as plt

def draw_EEG_epochs(epochs, channel, is_mean=False):
    fig = plt.figure(figsize=(20, 10))
    ax = fig.add_subplot(1, 1, 1)

    xticks = np.linspace(-2000, 5000, epochs.shape[2])  # 시간축 설정
    plotted_data = []
    
    if is_mean:
        plotted_data = np.mean(epochs[:, channel, :], axis=0)
        ax.plot(xticks, plotted_data)
    else:
        for epoch in epochs:
            ax.plot(xticks, epoch[channel, :])

    ylim = (np.min(plotted_data) - 1, np.max(plotted_data) + 1) if is_mean else (
        np.min(epochs[:, channel, :]) - 1, np.max(epochs[:, channel, :]) + 1)
    ax.set_title('EEG Epochs')
    ax.set_xticks(np.linspace(-2000, 5000, 8))
    ax.set_ylim(ylim)

    plt.show()

# 예제 사용
channel = 0  # 사용할 채널 인덱스 설정
draw_EEG_epochs(filtered_car_imagery_left_eeg, channel, is_mean=False)

