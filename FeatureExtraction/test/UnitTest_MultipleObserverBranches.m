clear
close all
clear

%%
f_sr = 50e3;

%% 
rsDAQ = RandSineAcquisitor(f_sr);

%%
prePro = DefaultPreprocessor();

%%
fwSeg = FixedWindowSegmenter(1000);

%%
ex = DefaultFeatureExtractor(f_sr);

funcHandle = @(x) getAmplitudeBins(x, f_sr);
trafo = Transformation('FFT-Trafo', funcHandle);
ex2 = FeatureExtractor('FFT-Extractor', trafo);

%%
plotter = HoldOnPlotter();
plotter2 = Plotter();

%%
rsDAQ.addObserver(prePro);
prePro.addObserver(fwSeg);
fwSeg.addObserver(ex);
fwSeg.addObserver(ex2);
ex.addObserver(plotter);
ex2.addObserver(plotter2);

%%
while (true)
    newData = rsDAQ.update([]);
end

function p = getAmplitudeBins(data, f_sr)
    [~, p, ~] = SignalAnalysis.fftPowerSpectrum(data, f_sr);
end