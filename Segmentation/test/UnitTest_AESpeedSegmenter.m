%%
AE_FOLDER = 'U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\5-Achser-KGT-Measurements\20210118_mess_ae_kgt_cam\Verschleissfahrt3\';
PLC_FOLDER = 'U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\5-Achser-KGT-Measurements\20210118_mess_ae_kgt_cam\Verschleissfahrt3\PLC_LOG\';

aeFiles = DataParser.getFilePaths(AE_FOLDER, 'mat', 'ORFL', true);
load('U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_3_MATLAB\Eval_AE_Data\Verschleissfahrt3\onlyNoisyData_5Achser_Verschleissfahrt3.mat')
aeFiles(logical(onlyNoiseData), :) = [];

plcFiles = DataParser.getFilePaths(PLC_FOLDER, 'mat', [], true);

dp_ae = DataParser();

%%

simStream = AEPLCSimStreamAcquisitor(dp_ae, aeFiles, plcFiles);
simStream.dataPersistent = true;
simStream.dataStream.idx = 10000;

%%
aeSegmenter = AESpeedSegmenter();
simStream.addObserver(aeSegmenter);


%%

while (simStream.dataStream.moreDataAvailable)
    simStream.update([]);
    
    data = simStream.dataBuffer;
    t_a = data{1, 1};
    d_a = data{2, 1};
    t_p = data{3, 1};
    d_p = data{4, 1};
    subplot(2,1,1)
        plot(t_a, d_a)
    subplot(2,1,2)
        plot(t_p, d_p)
        
    drawnow
end
