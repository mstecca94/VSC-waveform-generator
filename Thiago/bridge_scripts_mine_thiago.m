Converter.Wav.UcA = Wave.Voltage.v_a ;
Converter.Wav.UcB = Wave.Voltage.v_b ;
Converter.Wav.UcC = Wave.Voltage.v_c ;

Converter.Wav.UgA = Wave.Voltage.Vga ;
Converter.Wav.UgB = Wave.Voltage.Vgb ;
Converter.Wav.UgC = Wave.Voltage.Vgc ;

Converter.Spec.Lf  = 320e-6;      %[H]  : Converter Side Inductor
Converter.Spec.Lfeq  = 320e-6;      %[H]  : Converter Side Inductor
% Converter.Spec.L1_Vvar = [1.0 1.0 1.0 1.0 1.0]; % Variation of Lf as function of Current
Converter.Spec.Lg = 37.0e-6;        %[H]  : Grid Side Inductor
Converter.Spec.Cf  = 17.5e-6;       %[F]  : LCL Filter Capacitor

Converter.Spec.Lf  = Wave.Input.Lc;      %[H]  : Converter Side Inductor
Converter.Spec.Lfeq  = Wave.Input.Lc ;      %[H]  : Converter Side Inductor
% Converter.Spec.L1_Vvar = [1.0 1.0 1.0 1.0 1.0]; % Variation of Lf as function of Current
Converter.Spec.Lg = Wave.Input.Lg;        %[H]  : Grid Side Inductor
Converter.Spec.Cf  = Wave.Input.C;       %[F]  : LCL Filter Capacitor

Converter.Spec.Lp = 1.5e-3;               %[H]  : Self-Inductance ICT
Converter.Spec.kp = 0.9;                  %0..1 : Coupling factor
                                          % kp =sqrt(1-sigma); sigma = field leakage factor
                          
Converter.Spec.filterType = 'LCL' ;
Converter.Spec.wiringType = '3wire' ;
Converter.Wav.t = Wave.Input.t ;
Converter.Wav.ILcABC_50Hz = Wave.Current.i_50Hz_a ;
Converter.Wav.ILgABC_50Hz = Wave.Current.i_50Hz_a ;

[ Converter ] = thiago_script_LCL ( Converter )

figure;
hold on
plot(Wave.Current.i_grid_side)
plot(Converter.Wav.ILgABC(1,:))
legend('Marco','Thiago')
grid on

figure;
hold on
plot(Wave.Current.i_converter_side)
plot(Wave.Current.i_converter_side_dmpd)
plot(Converter.Wav.ILcABC(1,:))
legend('Marco','Marco DMPD','Thiago')
grid on
