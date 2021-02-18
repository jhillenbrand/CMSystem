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