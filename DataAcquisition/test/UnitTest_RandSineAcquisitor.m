%%

rsDAQ = RandSineAcquisitor();

%%

for i = 1 : 15  
    SignalAnalysis.fftPowerSpectrum(rsDAQ.requestAvailableData(), rsDAQ.sampleRate, 'DualPlot', true, 'NewFigure', false);
    drawnow
end