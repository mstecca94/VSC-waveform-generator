% Author: Thiago Soeiro
% Date of Last Update: 13.07.2016 
function [ Core ] = Wdg_Loss_Analyt_Losses( Core )
T = Core.Tmax; % Temperature winding for the worst case scenario
if strcmp(Core.CondMat,'CU')
    sigma = 1 / (0.01784e-6 * (1 + 3.92e-3 * (T - 20)));    
elseif strcmp(Core.CondMat,'AL')
    sigma = 1 / (0.0282e-6 * (1 + 3.9e-3 * (T - 20)));    
end

%skin_depth = 1/sqrt(pi*u0*sigma*f);
di = Core.Wire.d_strand; % Diameter of a Single Strand
da = Core.Wire.d_wire; % Litz Cable Diameter
l_avg = Core.Wire.Turn_Length;   %   Total Turn Length: N * MeanTurnLength
nr_of_strands = Core.Wire.n_strand; % Number of Strands
Ipp_LF = 2*Core.Ipk_Rated; % Peak to Peak Current
Ipp_HF = Core.Ipp_Fs; % Peak to Peak Current
fs = Core.fsMax;

[FR, GR, RDC] = winding_loss.round_conductor(sigma, di, fs);
% Here it is considered the windown is Fully Utilized
% ML : Number of completed layers in the bobin. In case a layer is not complete, this must be considered separately
% N  : Number of turns
% NL : Number of wires per layer
% bF : Window Heigth

% Here it is considered that all high-frequency current ripple has a component at
% the switching frequency - Above all it seems a very conservative approach
% in Inverter applications

switch Core.CoreType
    case 'Toroidal' % Toroidal Powder Cores from Changsung
        if (Core.N >Core.Nmax_p)
            ML = 2;
            NL = ceil(Core.N/2);
            bF = Core.N*(da)/ML;
        else
            ML = 1;
            NL = Core.N;
            bF = Core.N*(da);
        end
        Core.Pskin = 1.0 * nr_of_strands * l_avg * RDC * FR * (Ipp_HF/2/nr_of_strands)^2 + nr_of_strands * l_avg * RDC * 0.5 * (Ipp_LF/2/nr_of_strands)^2;
        % Pprox is a rough approx.
        Core.Pprox = 1.0 * nr_of_strands * l_avg/Core.N * RDC * GR * (Ipp_HF/2)^2 * ( Core.N / ( 2 * pi^2 * da^2 ) + NL^3 * ML * ( 4*ML^2 - 1 ) / (12 * bF^2));
        
%         % Alternative Calculation
%         u0=4*pi*1e-7;
%         delta = 1/sqrt(pi*u0*sigma*fs);
%         chi=(pi/4)^(3/4)*sqrt(0.8)*di/delta;
%         % RDC
%         RDC2 = 4/(sigma*di^2*pi);
%         % High Frequency Loss
%         FR2 = chi*( (exp(2*chi) - exp(-2*chi) + 2*sin(2*chi))/(exp(2*chi) + exp(-2*chi) - 2*cos(2*chi))  +  2/3*(ML^2-1)*(exp(chi) - exp(-chi) - 2*sin(chi))/(exp(chi) + exp(-chi) + 2*cos(chi)) );
%         Core.Pskin = 1.0 * nr_of_strands * l_avg * RDC2 * FR2 * (Ipp_HF/2/nr_of_strands)^2 + nr_of_strands * l_avg * RDC * 0.5 * (Ipp_LF/2/nr_of_strands)^2;
%         Core.Pprox = 0;
        
    case 'UU'
        NL = floor(2*(Core.hw-Core.e)/(Core.Wire.d_wire + 2*Core.Wire.d_ISO)); % Max. possible No. of Turns per layer
        ML = ceil(Core.N/2/NL);
        if ML>1
            bF = NL*da;%2*(Core.hw-Core.e);
        else
            bF = Core.N/2*da;
        end
        Core.Pskin = 1.0 * nr_of_strands * l_avg * RDC * FR * (Ipp_HF/2/nr_of_strands)^2 + nr_of_strands * l_avg * RDC * 0.5 * (Ipp_LF/2/nr_of_strands)^2;
        Core.Pprox = 1.0 * nr_of_strands * l_avg/Core.N * RDC * GR * (Ipp_HF/2)^2 * ( Core.N / ( 2 * pi^2 * da^2 ) + 2* NL^3 * ML * ( 4*ML^2 - 1 ) / (12 * bF^2));
        
    case 'EE'
        NL = floor(2*(Core.hw-Core.e)/(Core.Wire.d_wire + 2*Core.Wire.d_ISO)); % Max. possible No. of Turns per layer
        ML = floor(Core.N/NL);
        if ML>1
            bF = NL*da;%2*(Core.hw-Core.e);
        else
            bF = Core.N*da;
        end
        Core.Pskin = 1.0 * nr_of_strands * l_avg * RDC * FR * (Ipp_HF/2/nr_of_strands)^2 + nr_of_strands * l_avg * RDC * 0.5 * (Ipp_LF/2/nr_of_strands)^2;
        Core.Pprox = 1.0 * nr_of_strands * l_avg/Core.N * RDC * GR * (Ipp_HF/2)^2 * ( Core.N / ( 2 * pi^2 * da^2 ) + NL^3 * ML * ( 4*ML^2 - 1 ) / (12 * bF^2));
        
    case 'EE Integrated'
        NL = floor(2*(Core.hw-Core.e)/(Core.Wire.d_wire + 2*Core.Wire.d_ISO)); % Max. possible No. of Turns per layer
        ML = floor(Core.N/NL);
        if ML>1
            bF = NL*da;%2*(Core.hw-Core.e);
        else
            bF = Core.N*da;
        end
        Core.Pskin = 1.0 * nr_of_strands * l_avg * RDC * FR * (Ipp_HF/2/nr_of_strands)^2 + nr_of_strands * l_avg * RDC * 0.5 * (Ipp_LF/2/nr_of_strands)^2;
        Core.Pprox = 1.0 * nr_of_strands * l_avg/Core.N * RDC * GR * (Ipp_HF/2)^2 * ( Core.N / ( 2 * pi^2 * da^2 ) + NL^3 * ML * ( 4*ML^2 - 1 ) / (12 * bF^2));


end
Core.Pw = Core.Pskin + Core.Pprox;

end

