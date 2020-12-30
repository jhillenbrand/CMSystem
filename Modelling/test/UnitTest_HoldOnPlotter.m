%% 

rsDAQ = RandSineAcquisitor();

%%

plotter = HoldOnPlotter();

%%

rsDAQ.addObserver(plotter);

%%

rsDAQ.update();