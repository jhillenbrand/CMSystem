%%
clear
close all
clc

%%
sgAcq = SineGenAcquisitor(300, 100);
sgAcq.f1 = 1;
sgAcq.f2 = 2;
sgAcq.a1 = 1.75;
sgAcq.a2 = 5;
sgAcq.no1 = 0.25;
sgAcq.no2 = 0.25;

%% 
subPlotter = HoldOnSubPlotter(1);

%%
sgAcq.addObserver(subPlotter);

%% collect data for training
numOfWindows = 200;
w = 0;
XTrain = [];
while w < numOfWindows
    w = w + 1;
    newData = sgAcq.requestData();
    sgAcq.transfer(newData);
    XTrain = [XTrain, newData];
    xlabel('Samples [-]')
    ylabel('Raw Signal [-]')
end

%% learn
aenEx = AutoencoderExtractor();
aenEx.defaultLearn(XTrain');

%% reconstruction example
figure;
newData = sgAcq.requestData();
data_Pred = predict(aenEx.autoencoder, newData');
mse = mean(SignalAnalysis.getMSE(newData, data_Pred', 2));
plot(newData, 'r')
hold on
plot(data_Pred', 'b')
legend({'Original', 'Reconstructed'})
title(['MSE Error: ' num2str(mse)])
grid on
grid minor

%%
sgAcq.addObserver(aenEx);

subPlotter.numOfSubplots = 2;
aenEx.addObserver(subPlotter);

%%
switchW = 15;
w = 0;

figure(subPlotter.F)

subplot(2,1,1)
xlabel('Samples [-]')
ylabel('Raw Signal [-]')
subplot(2,1,2)
xlabel('Samples [-]')
ylabel('MSE Error [-]')

while true
    w = w + 1;
    if w < switchW
        sgAcq.update();
    else
        sgAcq.f1 = 3;
        sgAcq.f2 = 5;
        sgAcq.a1 = 1;
        sgAcq.a2 = 5;
        sgAcq.no1 = 0.35;
        sgAcq.no2 = 0.35;
        sgAcq.update();
    end
    if w > 2 * switchW
        break;
    end
end

%%

