function [ Converter ] = thiago_script_LCL ( Converter )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Filter Response
%% Alpha & Beta Space-State model for frequencies > 50Hz (Grid voltage is always zero)
% Get rid of the Fundamental Component and perform Alpha, Beta, Zero Transformation
UxABC = [Converter.Wav.UcA - Converter.Wav.UgA; Converter.Wav.UcB - Converter.Wav.UgB; Converter.Wav.UcC - Converter.Wav.UgC];
U_alpha =   2/3*(    UxABC(1,:)        -0.5*UxABC(2,:)       -0.5*UxABC(3,:));
U_beta =    2/3*(                 sqrt(3)/2*UxABC(2,:) -sqrt(3)/2*UxABC(3,:));
U_zero =    2/3*(0.5*UxABC(1,:)        +0.5*UxABC(2,:)       +0.5*UxABC(3,:)); 
t=Converter.Wav.t;
% Model LCL Filter + ICT + Damping Resistor                             
% Converter.Spec.Lfeq =0.5*(2*Converter.Spec.Lf + (1 - Converter.Spec.kp)*Converter.Spec.Lp);
L_filtConv = Converter.Spec.Lfeq;
L_filtGrid = Converter.Spec.Lg;
C_filt = Converter.Spec.Cf;
Rc = 1e-3; % Resistance in Series with Converter-side Inductance
Rg = 1e-3; % Resistance in Series with Grid-side Inductance
%LCL Filter Resonant Frequency
f_res = sqrt((L_filtConv + L_filtGrid)/(L_filtConv*L_filtGrid*C_filt))/2/pi;

%LC Filter Resonant Frequency
f_LC = sqrt(1/L_filtConv/C_filt)/2/pi;

% Assumed controller bandwidth
controller_bandwidth =max(f_res,f_LC)*1.3;    

switch Converter.Spec.filterType
    case {'LCL'}
        % X = [iLc uCf iLg];
        % u = [uc];
        % Y = X = [iLc uCf iLg];
        x0 = [eps; eps; eps]; % Initial varibles for the SS
        Ax = [-Rc/L_filtConv  -1/L_filtConv   0;
            1/C_filt     0    -1/C_filt;
            0     1/L_filtGrid   -Rg/L_filtGrid];
        Bx = [1/L_filtConv;
            0;
            0];
        Cy = [1 0 0;
            0 1 0;
            0 0 1];
        Dy = [0;
            0;
            0];        
        % Transfer Function  of the LCL filter:
        [num,den]=ss2tf(Ax,Bx,Cy,Dy);
        %Admittance Y31 = Igrid/Vconv
        Y31 = tf(num(3,:),den);
        %Admittance Y11 = Iconv/Vconv
        Y11 = tf(num(1,:),den);
end
%%
switch Converter.Spec.wiringType
    case '4wire'
        %% Frequency Domain Analysis        
        % Frequency Response of the LCL Filter Converter Side
        UxA = UxABC(1,:);
        N_samples = length(UxA);
        freq_y = [0:N_samples/2-1]/t(end);
        
        U_xA_fft = fft(UxA,N_samples,2);
        bode_Y11 = freqresp(Y11,freq_y, 'Hz');
        bode_Y11 = transpose(squeeze(bode_Y11(1,1,:)));
        bode_Y31 = freqresp(Y31,freq_y, 'Hz');
        bode_Y31 = transpose(squeeze(bode_Y31(1,1,:)));
        
        % Assume that the controller and active damping scheme can cancel all harmonics up to 1.3*max(f_res,f_LC)
        bode_Y11(1:round(controller_bandwidth*t(end))) =   0;
        bode_Y31(1:round(controller_bandwidth*t(end))) =   0;
        
        % Frequency Response of the LCL Filter Converter Side
        i_convA_fft = U_xA_fft(:,1:N_samples/2).*[bode_Y11;bode_Y11];
        i_convA_fft = [i_convA_fft,fliplr(conj(i_convA_fft))];
        %%
        IconvA_HF = ifft(i_convA_fft,N_samples,2,'symmetric');
        Converter.Wav.ILcABC_HF = IconvA_HF(1,:);
        %%
        % Frequency Response of the LCL Filter grid side
        i_gridA_fft = U_xA_fft(:,1:N_samples/2).*[bode_Y31;bode_Y31];
        i_gridA_fft = [i_gridA_fft,fliplr(conj(i_gridA_fft))];
        IgridA_HF = ifft(i_gridA_fft,N_samples,2,'symmetric');
        Converter.Wav.ILgABC_HF = IgridA_HF(1,:);       
        
        % Converter-Side Currents
        Converter.Wav.ILcABC = Converter.Wav.ILcABC_HF + Converter.Wav.ILcABC_50Hz;
        
        % Grid-Side Currents
        Converter.Wav.ILgABC = Converter.Wav.ILgABC_HF + Converter.Wav.ILgABC_50Hz;
        
        % AC Capacitor Current
        Converter.Wav.ICfABC = Converter.Wav.ILcABC - Converter.Wav.ILgABC;
        
    case '3wire'
        %% Frequency Domain Analysis        
        % Frequency Response of the LCL Filter Converter Side
        N_samples = length(U_alpha);
        freq_y = [0:N_samples/2-1]/t(end);
        
        U_alphaBeta_fft = fft([U_alpha;U_beta],N_samples,2);
        bode_Y11 = freqresp(Y11,freq_y, 'Hz');
        bode_Y11 = transpose(squeeze(bode_Y11(1,1,:)));
        bode_Y31 = freqresp(Y31,freq_y, 'Hz');
        bode_Y31 = transpose(squeeze(bode_Y31(1,1,:)));
        
        % Assume that the controller and active damping scheme can cancel all harmonics up to 1.3*max(f_res,f_LC)
        bode_Y11(1:round(controller_bandwidth*t(end))) =   0;
        bode_Y31(1:round(controller_bandwidth*t(end))) =   0;
        
        % Frequency Response of the LCL Filter Converter Side
        i_convAlphaBeta_fft = U_alphaBeta_fft(:,1:N_samples/2).*[bode_Y11;bode_Y11];
        i_convAlphaBeta_fft = [i_convAlphaBeta_fft,fliplr(conj(i_convAlphaBeta_fft))];
        IconvAlphaBeta_HF = ifft(i_convAlphaBeta_fft,N_samples,2,'symmetric');
        Converter.Wav.ILcABC_HF = [     IconvAlphaBeta_HF(1,:);...
            -0.5*IconvAlphaBeta_HF(1,:)+sqrt(3)/2*IconvAlphaBeta_HF(2,:);...
            -0.5*IconvAlphaBeta_HF(1,:)-sqrt(3)/2*IconvAlphaBeta_HF(2,:)];
        
        % Frequency Response of the LCL Filter grid side
        i_gridAlphaBeta_fft = U_alphaBeta_fft(:,1:N_samples/2).*[bode_Y31;bode_Y31];
        i_gridAlphaBeta_fft = [i_gridAlphaBeta_fft,fliplr(conj(i_gridAlphaBeta_fft))];
        IgridAlphaBeta_HF = ifft(i_gridAlphaBeta_fft,N_samples,2,'symmetric');
        Converter.Wav.ILgABC_HF = [     IgridAlphaBeta_HF(1,:);...
            -0.5*IgridAlphaBeta_HF(1,:)+sqrt(3)/2*IgridAlphaBeta_HF(2,:);...
            -0.5*IgridAlphaBeta_HF(1,:)-sqrt(3)/2*IgridAlphaBeta_HF(2,:)];       
        
        % Converter-Side Currents
        Converter.Wav.ILcABC = Converter.Wav.ILcABC_HF + Converter.Wav.ILcABC_50Hz;
        
        % Grid-Side Currents
        Converter.Wav.ILgABC = Converter.Wav.ILgABC_HF + Converter.Wav.ILgABC_50Hz;
        
        % AC Capacitor Current
        Converter.Wav.ICfABC = Converter.Wav.ILcABC - Converter.Wav.ILgABC;
                       
    case '3wire_VG'  
        
   
end

figure;
hold on
plot(Converter.Wav.ILgABC(1,:))
plot(Converter.Wav.ILcABC(1,:))
legend('Grid side','Converter Side')

% % ARM Currents
% Converter.Wav.i_ArmUpper =Converter.Wav.ILcABC_HF(1,:)/2 + Converter.Wav.I_circ_HF + Converter.Wav.IarmA_upper_50Hz;
% Converter.Wav.i_ArmLower =-Converter.Wav.ILcABC_HF(1,:)/2 + Converter.Wav.I_circ_HF + Converter.Wav.IarmA_lower_50Hz;

%%  Useful Data
%LCL Filter
WaveformData.LCL.i_filtInductorConv =   Converter.Wav.ILcABC(1,:);
WaveformData.LCL.i_filtInductorGrid =   Converter.Wav.ILgABC(1,:);
WaveformData.LCL.i_filtCapacitor =      Converter.Wav.ICfABC(1,:);