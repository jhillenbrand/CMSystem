%% Setup Files to Parse
paths = DataParser.selectMultipleFilesFolders();
files = DataParser.getFilesInFolders(paths,'mat');
if isempty(files)
    files = paths;

end

%%

rsDAQ = SimStreamAcquisitor(files,1e6,2e6/10);

%%

while rsDAQ.DataStream.moreDataAvailable  
    SignalAnalysis.fftPowerSpectrum(rsDAQ.requestAvailableData(), 3e10, 'DualPlot', true, 'NewFigure', false);
    drawnow
end