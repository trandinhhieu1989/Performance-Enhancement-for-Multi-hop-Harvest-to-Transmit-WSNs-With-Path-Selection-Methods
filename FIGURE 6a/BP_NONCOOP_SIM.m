function h_out = BP_NONCOOP_SIM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,Num_Trial,kappa)
% BP_SIM    : Simulation of Shorstest Path Protocol
% PdB       : Transmit power of beacons
% IdB       : Interference Constraints
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
OUT_SM = zeros(length(alpha), length(PdB));
for k = 1 : length(alpha)
    fprintf('Running %d per %d \n',k,length(yE));
for aa = 1:length(PdB)
    OUT_SM(k,aa) = BPfunc(PdB(aa),IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha(k),Num_Trial,kappa) ;
end
end
OUT_SM
h_out = semilogy(alpha,OUT_SM,'ro'); grid on;hold on;
end

function out = BPfunc(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,Num_Trial,kappa) 
PP          = 10.^(PdB/10);
II          = 10.^(IdB/10);
% OP: Outage Probability
OP          = zeros(1,length(PP));
% Define kappa
kp          = eta*alpha/(1-alpha);
%
for aa = 1 : length(PP)
    
    for bitnum   =  1 : Num_Trial
        % Find best path with highest capacity
        CC_max  = 0;
        for bb = 1 : length(LL)
            % Number of hops
            Hop  = LL(bb) + 1;
            % rho at each hop
            rho  = 2^(Hop*RR/(1 - alpha)) - 1;
            % Find end-to-end SNR
            SNRmin   = inf;
            %
            for cc = 1 : Hop
                % Parameter of data links: Lambda_D
                LD    = (1/Hop)^PL;
                % Parameter of energy harvesting links: Lambda_B
                LB    = sqrt(((cc-1)/Hop - xB)^2 + yB^2)^PL;               
                % Parameter of eavesdopping links: Lambda_E
                LE    = sqrt(((cc-1)/Hop - xE)^2 + yE^2)^PL;
                % Rayleigh fading channel of data links
                hD    = sqrt(1/LD/2)*(randn(1,1)+j*randn(1,1));                    
                % Power from energy harvesting
                hB    = sqrt(1/LB/2)*(randn(1,1)+j*randn(1,1));
                P_EH  = kp*PP(aa)*abs(hB)^2;                                                         
                % Rayleigh fading channel of eavesdopping links
                SNR_E_max = 0;
                for dd = 1 : KK
                    hE    = sqrt(1/LE/2)*(randn(1,1)+j*randn(1,1));
                    if (abs(hE)^2 > SNR_E_max)
                        SNR_E_max = abs(hE)^2;
                    end
                end                                              
                % Power constrained due to the presence of eavesdopper
                P_Eav = rho/SNR_E_max/(1-kappa*rho);                                   
                % Transmit power
                if (kappa <= 1/rho)
                    P_t   = min(P_EH, P_Eav);
                else
                    P_t   = P_EH;    
                end
                % Signal-to-noise ratio (SNR)
                SNR   = P_t*abs(hD)^2/(kappa*P_t*abs(hD)^2+1);
                if (SNR < SNRmin)
                    SNRmin = SNR;
                end
            end
            % End-to-end channel capacity
            CC       = (1-alpha)/Hop*log2(1 + SNRmin);
            if (CC > CC_max)
                CC_max = CC;
            end
        end
        %
        if (CC_max <= RR)
            OP(aa) = OP(aa) + 1;
        end
    end
end
%
out = OP./Num_Trial;
%OP
%

end





