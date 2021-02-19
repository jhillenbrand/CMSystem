%%
clear
close all
clc

%%

aeSystem = AEncoderMonitoringSystem();

%%
aeSystem.saveToFilePath = 'cmsystem_save.mat';
aeSystem.buildFromFile();

%%

aeSystem.start();

%%
aeSystem.merger.dataBuffer = [];
aeSystem.merger.transformCount = 0;

%%
aeSystem.switchStrategy('MonitoringStrategy');
aeSystem.activeStrategy.execute(aeSystem);