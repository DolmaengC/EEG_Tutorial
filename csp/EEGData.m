classdef EEGData
    properties
        FileName
        noise
        rest
        srate
        movement_left
        movement_right
        movement_event
        n_movement_trials
        imagery_left
        imagery_right
        n_imagery_trials
        frame
        imagery_event
        comment
        subject
        bad_trial_indices
        psenloc
        senloc
        chanlocs % 추가된 필드
    end
    
    methods
        function obj = EEGData(fileName)
            % 생성자 메서드
            obj.FileName = fileName;
            obj.noise = {};
            obj.rest = [];
            obj.srate = [];
            obj.movement_left = [];
            obj.movement_right = [];
            obj.movement_event = [];
            obj.n_movement_trials = [];
            obj.imagery_left = [];
            obj.imagery_right = [];
            obj.n_imagery_trials = [];
            obj.frame = [];
            obj.imagery_event = [];
            obj.comment = '';
            obj.subject = '';
            obj.bad_trial_indices = {};
            obj.psenloc = [];
            obj.senloc = [];
            obj.chanlocs = []; % 초기화
        end
        
        function obj = readFile(obj)
            % 파일을 읽고 데이터를 저장
            data = load(obj.FileName);
            
            disp(['Variables in the .mat file ', obj.FileName, ':']);
            disp(fieldnames(data));

            if isfield(data, 'eeg')
                eeg_data = data.eeg;
                disp('EEG Data:');
                disp(eeg_data);
                
                if isfield(eeg_data, 'noise')
                    obj.noise = eeg_data.noise;
                end
                if isfield(eeg_data, 'rest')
                    obj.rest = eeg_data.rest;
                end
                if isfield(eeg_data, 'srate')
                    obj.srate = eeg_data.srate;
                end
                if isfield(eeg_data, 'movement_left')
                    obj.movement_left = eeg_data.movement_left;
                end
                if isfield(eeg_data, 'movement_right')
                    obj.movement_right = eeg_data.movement_right;
                end
                if isfield(eeg_data, 'movement_event')
                    obj.movement_event = eeg_data.movement_event;
                end
                if isfield(eeg_data, 'n_movement_trials')
                    obj.n_movement_trials = eeg_data.n_movement_trials;
                end
                if isfield(eeg_data, 'imagery_left')
                    obj.imagery_left = eeg_data.imagery_left;
                end
                if isfield(eeg_data, 'imagery_right')
                    obj.imagery_right = eeg_data.imagery_right;
                end
                if isfield(eeg_data, 'n_imagery_trials')
                    obj.n_imagery_trials = eeg_data.n_imagery_trials;
                end
                if isfield(eeg_data, 'frame')
                    obj.frame = eeg_data.frame;
                end
                if isfield(eeg_data, 'imagery_event')
                    obj.imagery_event = eeg_data.imagery_event;
                end
                if isfield(eeg_data, 'comment')
                    obj.comment = eeg_data.comment;
                end
                if isfield(eeg_data, 'subject')
                    obj.subject = eeg_data.subject;
                end
                if isfield(eeg_data, 'bad_trial_indices')
                    obj.bad_trial_indices = eeg_data.bad_trial_indices;
                end
                if isfield(eeg_data, 'psenloc')
                    obj.psenloc = eeg_data.psenloc;
                end
                if isfield(eeg_data, 'senloc')
                    obj.senloc = eeg_data.senloc;
                end
            else
                disp(['EEG data not found in file: ', obj.FileName]);
            end
        end
    end
end
