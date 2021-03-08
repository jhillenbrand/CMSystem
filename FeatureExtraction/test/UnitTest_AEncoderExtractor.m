clear
close all
clear

%%

f_sr = 2e6;
f_res = 100;

ex = AEncoderMemoryExtractor(f_sr, f_res);

%%

ex.autoencoder.setHiddenWidth(100);

%%

ex.learn(DATA);

%%
%%

ex = AEncoderMemoryExtractor(f_sr, f_res);

%%
ex.autoencoder = MyDeepAutoencoder(100, 1);
ex.autoencoder.setTrainingOptions('MaxEpochs',1000, 'Plots', 'training-progress');
ex.autoencoder.setIterativeTrainingOptions(...
    'ConvergencePatience',3,...
    'ScoreFactor',0.9);
ex.autoencoder.setValidationOptions('EarlyStopping', true,...
    'ValidationPatience',10,'Shuffle','once');
ex.autoencoder.setNormalizationOptions('NormalizationMethod', 'MapZscoreDataset');
ex.autoencoder.setIterativeTrainingOptions('UseIterativeTraining',true);  
            
%%

ex.learn(DATA);

%%

ex.autoencoder.plotReconstruction(DATA);


%% Example trainAutoencoder from MATLAB
rng(0,'twister'); % For reproducibility
n = 1000;
r = linspace(-10,10,n)';
x = 1 + r*5e-2 + sin(r)./r + 0.2*randn(n,1);

%%
hiddenSize = 100;
autoenc = trainAutoencoder(DATA, hiddenSize,...
        'EncoderTransferFunction','satlin',...
        'DecoderTransferFunction','purelin',...
        'L2WeightRegularization',0.0001,...
        'SparsityRegularization',0.0001,...
        'SparsityProportion',0.1);
    
%%
DATA_N = Mapping.scaleToRange(DATA, [0, 1], false);

%%

err = Mapping.getMaxRangeError(DATA_N, [0, 1]);


