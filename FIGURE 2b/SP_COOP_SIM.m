function SP_COOP_SIM(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,Num_Trial,kappa)    
% SP_SIM    : Simulation of Shorstest Path Protocol
% PdB       : Transmit power of beacons
% IdB       : Interference Constraints
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
% OP: Outage Probability
OP          = zeros(1,length(PP));
% Define kappa
kp          = eta*alpha/(1-alpha);
%
for aa = 1 : length(PP)
    fprintf('Running %d per %d \n',aa,length(PP));
    % Select shortest path, Lmin is the number of hops
    Lmin    = min(LL) + 1;
    % Define rho
    rho     = 2^(Lmin*RR/(1 - alpha)) - 1;     
    for bitnum   =  1 : Num_Trial       
        % Find end-to-end SNR
        SNRmin   = inf;
        for bb = 1 : Lmin
            % Parameter of data links: Lambda_D                         
            LD    = (1/Lmin)^PL;
            % Parameter of energy harvesting links: Lambda_B
            LB    = sqrt(((bb-1)/Lmin - xB)^2 + yB^2)^PL;        
            % Parameter of eavesdopping links: Lambda_E
            LE    = sqrt(((bb-1)/Lmin - xE)^2 + yE^2)^PL;
            % Rayleigh fading channel of data links
            hD    = sqrt(1/LD/2)*(randn(1,1)+j*randn(1,1));
            % Power from energy harvesting
            hB    = sqrt(1/LB/2)*(randn(1,1)+j*randn(1,1));
            P_EH  =  kp*PP(aa)*abs(hB)^2;                                                        
            % Rayleigh fading channel of eavesdopping links
            SNR_E_sum = 0;
            for dd = 1 : KK
                 hE        = sqrt(1/LE/2)*(randn(1,1)+j*randn(1,1));
                 SNR_E_sum = SNR_E_sum + abs(hE)^2;
            end                                              
            % Power constrained due to the presence of eavesdopper
             P_Eav = rho/SNR_E_sum /(1-kappa*rho);                                                
            % Transmit power
            P_t   = min(P_EH, P_Eav);
            % Signal-to-noise ratio (SNR)
            SNR   = P_t*abs(hD)^2/(kappa*P_t*abs(hD)^2+1);
            if (SNR < SNRmin)
                SNRmin = SNR;
            end            
        end
        % End-to-end channel capacity
        CC       = (1-alpha)/Lmin*log2(1 + SNRmin);                         
        %      
        if (CC <= RR)
            OP(aa) = OP(aa) + 1;
        end
    end
end
%
OP = OP./Num_Trial;
%
OP
%
semilogy(PdB,OP,'bs'); grid on;hold on;
%set(gca,'yscale','log');
end





