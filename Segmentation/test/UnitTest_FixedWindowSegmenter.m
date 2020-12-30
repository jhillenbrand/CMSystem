%% 

rsDAQ = RandSineAcquisitor();

%%

fwSegmentor = FixedWindowSegmenter(10e3);

%%

rsDAQ.addObserver(fwSegmentor);

%%

rsDAQ.update();