% This code describe the model including 1 Beacon, multi eavesdroppes and
% without PUs. It shows the relationship between outage probability and
% trasmit power.
tic
clear all;  clc;
PdB           = -5:2.5:35;
IdB           = 5;
LL            = [2 3 4];
PL            = 3;
RR            = 0.5;
% hardware impairment parameter
kappa         = 0.1;
%
xB            = 0.5;
yB            = 0.1;
%
xP            = 0.5;
yP            = -1;
%
KK            = 2;
xE            = 0.5;
yE            = 1;
%
eta           = 0.1;
alpha         = 0.1;
%
Num_Trial     = 5*10^6;
%
RP_COOP_SIM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,Num_Trial,kappa);
RP_THEORY(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);
RP_ASYM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);

% SPS Protocol
SP_COOP_SIM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,Num_Trial,kappa);
SP_THEORY(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);
SP_ASYM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);

% BPS Protocol
BP_COOP_SIM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,Num_Trial,kappa);
BP_THEORY(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);
BP_ASYM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);

legend('RPS - Sim','RPS - Exact', 'RPS - Asym','SPS - Sim','SPS - Exact', 'SPS - Asym','BPS - Sim','BPS - Exact', 'BPS - Asym');
xlabel('P (dB)');
ylabel('Outage probability (OP)');
toc