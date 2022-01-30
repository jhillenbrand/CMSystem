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
plotter = SubPlotter2(2);
plotter.axisLabels = {'RMS', 'P2P'; 'Amplitude [-]', 'Samples [-]'};
plotter.holdOn = [true, false];
sineAcquisitor.addObserver(plotter);

%%
merger = MergeTransformer('merger', 2);
rmsExtractor.addObserver(merger);
p2pExtractor.addObserver(merger);

%%
merger.addObserver(plotter);

%%
while (sineAcquisitor.isDataAvailable)
    sineAcquisitor.update([]);
    pause(0.1)
end

%%
h = gcf; 
%hf = h.Parent;
n = 250;
for i = 1 : n
    disp([num2str(i) '/' num2str(n)]);    
    sineAcquisitor.update([]);
    drawnow
    M(i) = getframe(h);
end

%%
movie(h, M, 1, 45);

%%
moviePath = 'video.mp4';
writerObj = VideoWriter(moviePath, 'MPEG-4');
writerObj.FrameRate = 3;
open(writerObj);
for i = 1 : length(M)
    writeVideo(writerObj, M(i));
end
close(writerObj);
winopen(moviePath);