%%
clear
close all
clc

%%
aeSystem = AEncoderMonitoringSystem();
aeSystem.AE_MAT_FOLDER = 'U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\1-Achser-Bearing-Measurements\20200721_axialbearing_baselineseries7\';
aeSystem.AE_FILE_TYPE = 'mat';
aeSystem.AE_FILE_NAME_ID = 'baseline';
aeSystem.windowSize = 100e3;
aeSystem.f_res = 10;
aeSystem.bitPrecision = 12;
aeSystem.lowPassFrequency = -1;
aeSystem.downsampleFactor = 1;
        
aeSystem.saveToFilePath = 'cmsystem_blank_save.mat';

aeSystem.initTransformers();

aeSystem.saveToFile();

%%
aeSystem.start();

%%