function h_out = BP_THEORY(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa)
% BP_THEORY  : Theory of Best Path Protocol
% OP: Outage Probability
OP_LT = zeros(length(xB), length(PdB));
for k = 1 : length(xB)
for aa = 1 : length(PdB)
    OP_LT(k,aa) = BPfunc(PdB(aa),IdB,LL,KK,PL,RR,xB(k),yB,xE,yE,eta,alpha,kappa);
end
end
%
OP_LT
%
h_out = semilogy(xB,OP_LT,'r-'); grid on;hold on;
end
%
function out = BPfunc(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa)
% PdB       : Transmit power of beacons
% QdB       : Interference Constraints
% NN        : Number of Beacons
% LL        : a vectors including the number of intermediate nodes on each path
% PL        : Path-Loss
% RR        : Target Rate
% xB, yB    : co-ordinates of Beacons
% xP, yP    : co-ordinates of Primary Users
% xE, yE    : co-ordinates of Eavesdopper
% eta       : energy harvesting efficiency
% alpha     : fraction of time for energy harvesting
% Num_Trial : Number of Trials
% From dB to Watt
PP          = 10.^(PdB/10);
II          = 10.^(IdB/10);
% Define kappa
kp          = eta*alpha/(1-alpha);
% OP: Outage Probability
out         = 1;
%
for aa = 1 : length(LL)
    %
    % the number of hops
    Hop        = LL(aa) + 1;
    % Define rho at each hop
    rho         = 2^(Hop*RR/(1 - alpha)) - 1;
    % Outage at each hop
    OP_hop      = 1;
  if (kappa < 1/rho)
    for bb = 1 : Hop
        % Parameter of data links: Lambda_D and Omega_D
        LD     = (1/Hop)^PL;
        % Parameter of energy harvesting links: Lambda_B and Omega_B
        LB     = sqrt(((bb-1)/Hop - xB)^2 + yB^2)^PL;
        OMB    = LB/PP/kp;       
        % Parameter of eavesdopping links: Lambda_E and Omega_E
        LE     = sqrt(((bb-1)/Hop - xE)^2 + yE^2)^PL;
        OME    = LE*rho/(1-kappa*rho);
        %
         hs     = 0;    
        gt1    = LD*2*sqrt(OMB*rho/LD/(1-kappa*rho))*besselk(1,2*sqrt(OMB*LD*rho/(1-kappa*rho)));
        hs     = hs + gt1;
        for k=0:KK-1
        gt3    = 2*OME^k*(1-kappa*rho)^k/(rho^k)/factorial(k)*LD*sqrt((OMB*rho/(1-kappa*rho))^(k+1)/(LD+OME*(1-kappa*rho)/rho)^(k+1))*besselk(-k-1,2*sqrt(OMB*rho/(1-kappa*rho)*(LD + OME*(1-kappa*rho)/rho)));
        hs     =  hs - gt3;
        end    
        %
        OP_hop = OP_hop*hs;
    end
    out = out*(1 - OP_hop);
  else    
    out = out * 1 ;
  end
end
end





