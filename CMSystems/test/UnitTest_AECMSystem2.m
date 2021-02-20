%%
clear
close all
clc

%%
aeSystem = AEncoderMonitoringSystem();
aeSystem.saveToFilePath = 'cmsystem_blank_save.mat';
aeSystem.saveToFile();

%%
aeSystem.saveToFilePath = 'cmsystem_blank_save.mat';
aeSystem.buildFromFile();

%%
aeSystem.saveToFilePath = 'cmsystem_save.mat';
aeSystem.start();

%%
aeSystem.merger.dataBuffer = [];
aeSystem.merger.transformCount = 0;

%%
aeSystem.switchStrategy('MonitoringStrategy');
aeSystem.activeStrategy.execute(aeSystem);

%%
aeSystem.switchStrategy('LearningStrategy');
aeSystem.activeStrategy.execute(aeSystem);

%% only visualize raw data preprocessing

plotter1 = MovingWindowPlotter(false, 10e6);
plotter2 = MovingWindowPlotter(false, 10e6);

aeSystem.rawAEPlotter.disable();
aeSystem.aeEncoderExtractor.disable();
aeSystem.rmsExtractor.disable();
aeSystem.clusteringModel.disable();
aeSystem.clusterPlotter.disable();

aeSystem.preprocessor.addObserver(plotter1);
aeSystem.lowPassProcessor.addObserver(plotter2);

while true
    aeSystem.aeDataAcquisitor.update([]);
end


