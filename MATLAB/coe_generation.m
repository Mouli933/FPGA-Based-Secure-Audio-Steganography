clc;
clear;
close all;

%% SELECT WAV FILE
[file, path] = uigetfile('*.wav', 'Select audio file');

if isequal(file,0)
    error('No file selected');
end

[audio, fs] = audioread(fullfile(path, file));

% Convert to mono if stereo
if size(audio,2) > 1
    audio = mean(audio,2);
end

%% NORMALIZE
audio = audio / max(abs(audio));

%% CONVERT TO 8-BIT (0–255)
audio = audio - min(audio);
audio = audio / max(audio);
data = uint8(audio * 255);

fprintf('Total samples: %d\n', length(data));

%% GENERATE COE FILE
fid = fopen('output.coe3','w');

fprintf(fid,'memory_initialization_radix=10;\n');
fprintf(fid,'memory_initialization_vector=\n');

for i = 1:length(data)-1
    fprintf(fid,'%d,\n',data(i));
end

fprintf(fid,'%d;\n',data(end));

fclose(fid);

disp('✅ COE file generated successfully!');
