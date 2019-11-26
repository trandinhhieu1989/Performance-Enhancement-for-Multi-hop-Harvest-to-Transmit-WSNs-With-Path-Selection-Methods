% This model includes Multiple Eaveasdroppers, 1 Beacons and without PUs
tic
clear all;  clc; close all;
PdB           = -5:2.5:35;
IdB           = 5;
LL            = [2 3 4];
% Path loss
PL            = 3;
% Predetermined data rate
RR            = 0.5;
% hardware impairment parameter
kappa         = 0.1;
%
xB            = 0.5;
yB            = 0.1;
%
%KK: number of eavesdroppers
KK            = 2;
xE            = 0.5;
yE            = 1;
%
eta           = 0.1;
alpha         = 0.1;
%
Num_Trial     = 10^5;%

% RPS Protocol
%RP_NONCOOP_SIM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,Num_Trial,kappa);
%RP_THEORY(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);
%RP_ASYM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);
% SPS Protocol
SP_NONCOOP_SIM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,Num_Trial,kappa);
SP_THEORY(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);
SP_ASYM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);
% BPS Protocol
%BP_NONCOOP_SIM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,Num_Trial,kappa);
%BP_THEORY(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);
%BP_ASYM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa);
%set(gca,'yscale','log');
%legend('RPS - Sim','RPS - Exact', 'RPS - Asym','SPS - Sim','SPS - Exact', 'SPS - Asym','BPS - Sim','BPS - Exact', 'BPS - Asym');
xlabel('SNR (dB)');
ylabel('Outage probability (OP)');
toc