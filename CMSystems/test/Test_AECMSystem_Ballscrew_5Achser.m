%%
clear
close all
clc

%%
aeSystem = AEncoderMonitoringSystem();
aeSystem.AE_MAT_FOLDER = 'U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\5-Achser-KGT-Measurements\20210118_mess_ae_kgt_cam\Verschleissfahrt3\';
aeSystem.AE_FILE_TYPE = 'mat';
aeSystem.AE_FILE_NAME_ID = 'ORLL';
aeSystem.windowSize = 100e3;
%aeSystem.f_res = 100;
aeSystem.f_res = 2e6/100e3;
aeSystem.bitPrecision = 12;
aeSystem.lowPassFrequency = 250;
aeSystem.downsampleFactor = 4;
        
aeSystem.saveToFilePath = 'cmsystem_blank_save.mat';

aeSystem.initTransformers();

aeSystem.saveToFile();

%%
aeSystem.start();

%%