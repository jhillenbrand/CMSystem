%%

bs = BallScrew.getBallScrewFromCatalog();
bs.calculateMissingGeometry();
bsm = BallScrewModeler(bs);
bsm.speedColumn = 1;
bsm.mode = 2;
bsm.periodOutput = false;
bsm.dataPersistent = true;

%%
load('U:\18_071_DFG_AE_KGT\4_Arbeitsinhalte\4_1_Measurements\5-Achser-KGT-Measurements\20210118_mess_ae_kgt_cam\Verschleissfahrt3\PLC_LOG\1612021902732_5Achser_plc.mat')
dp = DataParser();
dp.read(data);

%%
t = dp.getDataColumnByName('Sink Timestamp (CSV) [ms]');
s = dp.getDataColumnByName('SPEED [1/min]');
plot(t, s)

t1 = t(1:500);
s1 = s(1:500);
plot(t1, s1)

%%
bsm.update(s1);

FData = bsm.dataBuffer;
plot(FData)

max(max(FData))