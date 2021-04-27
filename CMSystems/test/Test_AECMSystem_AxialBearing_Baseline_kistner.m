%% ------------------------------------
%% Time Signal CM
aeSystem = AEncoderAxialBearingMonitoringSystem();
aeSystem.AE_MAT_FOLDER = 'F:\20210330_axialbearing_cmsystemTestAen\';
%aeSystem.AE_MAT_FOLDER = 'U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\1-Achser-Bearing-Measurements\20200721_axialbearing_baselineseries7\';
aeSystem.AE_FILE_TYPE = 'bin';
aeSystem.windowSize = 100e3;
aeSystem.f_res = 2e6/100e3;
aeSystem.bitPrecision = 12;
aeSystem.lowPassFrequency = -1;
aeSystem.downsampleFactor = 1;
        
aeSystem.saveToFilePath = 'cmsystem_blank_save.mat';

aeSystem.initTransformers();

aeSystem.saveToFile();

%%
aeSystem.start();

%% ----------------------------------------------------------------------
%% USE SPECTRUM MONITORING SYSTEM
clearvars -except jd
close all
clc
%%
aeSystem = AEncoderAxialBearingSpectrumMonitoringSystem_v2(jd);
%aeSystem.AE_MAT_FOLDER = 'D:\Dokumente\01_Studium\02_Master\05_Masterarbeit\01_Masterarbeit\3_Programming\Matlab\SourceCodeThesis\Datasets\20200721_axialbearing_baselineseries7\';
aeSystem.AE_MAT_FOLDER = 'F:\20210408_axialberaing_contaminationseries8';
aeSystem.AE_FILE_NAME_ID = 'spectrum_monitoring';
aeSystem.windowSize = 100e3;
aeSystem.f_res = 2e6/100e3;
aeSystem.bitPrecision = 12;
aeSystem.lowPassFrequency = -1;
aeSystem.downsampleFactor = 1;
        
aeSystem.saveToFilePath = 'cmsystem_blank_save.mat';

aeSystem.initTransformers();

aeSystem.clusterPlotter.enable();
aeSystem.rawAEPlotter.disable();

aeSystem.saveToFile();

%%
aeSystem.start();


