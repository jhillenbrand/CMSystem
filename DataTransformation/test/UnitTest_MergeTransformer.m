%% 
rsDAQ = RandSineAcquisitor();

%%
prePro = DefaultPreprocessor();

%%
ex1 = DefaultFeatureExtractor(50e3);
ex1.transformToMeanFrequency = false;
ex1.transformToPeakFactor = false;
ex1.initFeatureTransformations();

ex2 = DefaultFeatureExtractor(50e3);
ex2.transformToMeanFrequency = false;
ex2.transformToPeakFactor = false;
ex2.initFeatureTransformations();

%%
merger = MergeTransformer('Merger', 2);

%%
plotter = HoldOnPlotter();

%%
rsDAQ.addObserver(prePro);
rsDAQ.addObserver(ex1);
prePro.addObserver(ex2);
ex1.addObserver(merger);
ex2.addObserver(merger);
merger.addObserver(plotter);

%%
w = 0;
while (true)
    w = w + 1;
    rsDAQ.update([]);    
end