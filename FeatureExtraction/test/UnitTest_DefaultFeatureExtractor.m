%% 
rsDAQ = RandSineAcquisitor();

%%
prePro = DefaultPreprocessor();

%%
fwSeg = FixedWindowSegmenter(1000);

%%
ex = DefaultFeatureExtractor(50e3);

%%
plotter = HoldOnPlotter();

%%
rsDAQ.addObserver(prePro);
prePro.addObserver(fwSeg);
fwSeg.addObserver(ex);
ex.addObserver(plotter);

%%
while (true)
    rsDAQ.update();
end