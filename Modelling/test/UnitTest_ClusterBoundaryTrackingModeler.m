close all
%% 
rsDAQ = RandSineAcquisitor();

%%
prePro = DefaultPreprocessor();

%%
plotter3 = HoldOnPlotter();

%%
fwSeg = FixedWindowSegmenter(1000);

%%
ex = DefaultFeatureExtractor(50e3);

%%
clusterModeler = ClusterBoundaryTrackingModeler();

%%
plotter1 = ClusterTransitionPlotter();
plotter2 = ClusterStatePlotter();

%%
rsDAQ.addObserver(prePro);
prePro.addObserver(fwSeg);
prePro.addObserver(plotter3);
fwSeg.addObserver(ex);
ex.addObserver(clusterModeler);
clusterModeler.addObserver(plotter1);
clusterModeler.addObserver(plotter2);

%%
while (true)
    rsDAQ.update();
end