%% 
rsDAQ = RandSineAcquisitor();

%%
pl = Plotter();

%%
prePro = DefaultPreprocessor();

%%
fwSeg = FixedWindowSegmenter(1000);

%%
ex = DefaultFeatureExtractor(50e3);
ex.transformToRMS = true;
ex.transformToMeanFrequency = true;
ex.initFeatureTransformations();

%%
plotter = HoldOnPlotter();

%%
rsDAQ.addObserver(prePro);
rsDAQ.addObserver(pl);
prePro.addObserver(fwSeg);
fwSeg.addObserver(ex);
ex.addObserver(plotter);

%%
w = 0;
while (true)
    w = w + 1;
    rsDAQ.update([]);
     
    if w > 100
        prePro.disable();
    end
end