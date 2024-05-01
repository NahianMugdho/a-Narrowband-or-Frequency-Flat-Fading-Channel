sampleTime = 1/500000; % Sample Time
maxDopplerShift = 200; % Maximum Doppler Shift of diffusive components (Hz)
delayVector = 1.0e-004 * [0 0.0400 0.0800 0.1200]; % Discrete delays of
gainVector = [0 -3 -6 -9]; %Average path gains (dB)
specDopplerShift = 100; %Doppler shifts od specular component (Hz)
KFactor = 10; % Linear ratios of specular power to diffuse power
rayChanObj = rayleighchan(sampleTime, maxDopplerShift, delayVector, gainVector);
rayChanObj.StoreHistory = 1; % Store cahnnel state information as signal is processed for later visualization
ricChanObj = ricianchan(sampleTime, maxDopplerShift, KFactor, delayVector, gainVector, specDopplerShift);
ricChanObj.StoreHistory = 1; % Store channel state information as signal is processed for later visualization
hMod = comm.QPSKModulator('BitInput', true, 'PhaseOffset', pi/4);
bitsPerFrame = 1000;
msg = randi([0 1], bitsPerFrame, 1);
modSignal = step(hMod, msg);
filter(rayChanObj, modSignal);
filter(ricChanObj, modSignal);
plot(rayChanObj);
sampleTime = 1/20000; % 20 kb/s transmission
bitsPerFrame = 1000;
numFrames = 20;
rayChanObj = rayleighchan(sampleTime, maxDopplerShift, delayVector, gainVector);
rayChanObj.StoreHistory = 1;
rayChanObj.ResetBeforeFiltering = 0; % Retain channel stares across multiple frames.
for i=1:numFrames
    msg = randi([0 1], bitsPerFrame, 1); % Create data
    modSignal = step(hMod, msg); % Modulae Data
    filter(rayChanObj, modSignal); 
    plot(rayChanObj);
end
