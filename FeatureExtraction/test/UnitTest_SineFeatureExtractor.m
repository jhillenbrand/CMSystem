%%
clear
close all
clc 

%% 
sineAcquisitor = RandSineAcquisitor();
sineAcquisitor.minSamples = 1e3;
sineAcquisitor.maxSamples = 5e3;
sineAcquisitor.sampleRate = 5e3;
sineAcquisitor.maxFreq = 200;

%%
rmsExtractor = RMSExtractor();
sineAcquisitor.addObserver(rmsExtractor);

%% 
p2pExtractor = Peak2PeakExtractor();
sineAcquisitor.addObserver(p2pExtractor);

%%
plotter = Plotter(false, 'Sine Waves');
plotter.axisLabels = {'Amplitude [-]', 'Samples [-]'};
plotter.yAxisLimits = [-50, 50];
sineAcquisitor.addObserver(plotter);

%%
merger = MergeTransformer('merger', 2);
rmsExtractor.addObserver(merger);
p2pExtractor.addObserver(merger);

%%
holdOnPlotter = HoldOnPlotter('Feature Plot');
holdOnPlotter.axisLabels = {'RMS', 'P2P'};
merger.addObserver(holdOnPlotter);

%%
while (sineAcquisitor.isDataAvailable)
    sineAcquisitor.update([]);
    pause(0.1)
end

%%
h = gcf; 
hf = h.Parent;
n = 1000;
for i = 1 : n
    disp([num2str(i) '/' num2str(n)]);    
    sineAcquisitor.update([]);
    drawnow
    M(i) = getframe(hf);
end

%%
movie(hf, M, 1, 45);

%%
moviePath = 'video.mp4';
writerObj = VideoWriter(moviePath, 'MPEG-4');
writerObj.FrameRate = 60;
open(writerObj);
for i = 1 : length(M)
    writeVideo(writerObj, M(i));
end
close(writerObj);
winopen(moviePath);