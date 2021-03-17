%  Thiago B. Soeiro 
%  Last Change: 13.07.2013
function [ Core ] = FEMM_Analysis( Core )
addpath(genpath('C:\femm42'));
Core.unit= 'meters';
Core.modelname='DCAC_Inductor';
Core.con = 0.001; % For Unit conversion to SI Standards [metres]

Harm_Numb = Core.Number_of_Harmonics; % In Auto mode, this number of frequencies will be picked while in manual mode, the freq. no. depends on user input.

% For Generating MAT File to save results
%Result = struct([]);

% FFT of Current Signal
%----------------------------------------------------------
%waveform = load('DCDC_2L_Booster.txt');
waveform = Core.Wav.waveform;
[Ivec] = Current_FFT(waveform,Core); 
Core.Ivec = Ivec;
IS = waveform(:,2);
Core.L_IRMS = sqrt(mean(IS)^2 + std(IS)^2);
Core.waveform = waveform;
%% Electromagnetic Simulation of Inductor Model Using FEMM %%
%----------------------------------------------------------
I1 = 0;
openfemm; pause(1);
newdocument(0);

% -> **Pre-Processing Phase**
%----------------------------------------------------------
% Add Boundary conditions
%----------------------------------------------------------
mi_addboundprop('Z',0,0,0,0,0,0,0,0,0);

% Add Circuit properties
%----------------------------------------------------------
mi_addcircprop('W1',I1,1); 
mi_addcircprop('W2',I1,1);

% Add material properties
%----------------------------------------------------------
mi_addmaterial('A',  1,       1,       0,  0,0,    0,  0,0,0,0,0,0,0); % Group-1
%mi_addmaterial('FE', Core.mu_FE,   Core.mu_FE,   1.7,0,0.769,0.023,0,1,0,0,0,0,0); 
mi_addmaterial('FE', Core.mu_FE,   Core.mu_FE,   0,0,0,0,0,1,0,0,0,0,0); % Group-2
mi_addmaterial('CU', 1,1,0,0,Core.sigma/1e6,0,0,0,0,0,0,Core.n_strand,Core.d_strand*1e3); % Group-5/6/7/8/9/10 % Conductivity of Cu: 58e6 & AL: 35e6
mi_addmaterial('AL', 1,1,0,0,Core.sigma/1e6,0,0,0,0,0,0,Core.n_strand,Core.d_strand*1e3); % Group-5/6/7/8/9/10

% Geometry Design
%----------------------------------------------------------

%% Toroidal Core Selection
OD =  Core.OD;      %[m] Outer Diameter
ID =  Core.ID;      %[m] Inner Diameter
HT =  Core.HT;      %[m] Core Height
wg = Core.e;        %[m] Bobine Distance to Core

%% Windings Properties
N  = Core.N;            %  [Turns]
diameter = Core.d_wire; % Wire Diameter in m.
isol = Core.d_ISO;      % Wire Isolation Distances in m
MLT = Core.Turn_Length/N; %Mean Turn Length
%% Set Bondaries of Simulations
Lim = 2*OD;
mi_drawrectangle(-1*Lim/2,-1*Lim/2,+1*Lim/2,+1*Lim/2);
mi_selectsegment(-1*Lim/2,-1*Lim/2+1*Core.con);
mi_selectsegment(-1*Lim/2+1*Core.con,-1*Lim/2);
mi_selectsegment(+1*Lim/2,+1*Lim/2-1*Core.con);
mi_selectsegment(+1*Lim/2-1*Core.con,+1*Lim/2);
mi_setsegmentprop('A=0', 0, 1, 0, 0);

% Set Air as Fluid
mi_addblocklabel(-Lim/2+2*Core.con,-Lim/2+2*Core.con);
mi_selectlabel(-Lim/2+2*Core.con,-Lim/2+2*Core.con);
mi_setblockprop('A', 1, 1, 'none', 0, 1, 0);
mi_clearselected();       

%% Draw & SET Cores
% Draw Left Hand Side Windings
x = OD/2;
y = 0.0;
x1 = ID/2;
y1 = y;

mi_drawarc(x,y,x-OD,y,180,10);
mi_drawarc(x-OD,y,x,y,180,10);   

mi_drawarc(x1,y1,x1-ID,y1,180,10);
mi_drawarc(x1-ID,y1,x1,y1,180,10);
mi_addblocklabel(x1+(OD-ID)/4,y1);
mi_selectlabel(x1+(OD-ID)/4,y1);
mi_setblockprop('FE', 1, 1, 'none', 0, 2, 0);
mi_clearselected();

% Set Core Center Air as Fluid
mi_addblocklabel(0,0);
mi_selectlabel(0,0);
mi_setblockprop('A', 1, 1, 'none', 0, 1, 0);
mi_clearselected();


%% Draw & SET Windings
% Set Windings Current
mi_modifycircprop('W1', 1, I1);
%mi_modifycircprop('W2', 1, -I1);

% Outer Windings
hw = 2*pi*OD/2; % [m] largest window height for outer windings
Nt_outer = hw/(diameter + 2*isol);        
if (Nt_outer >= N)
    ang = 2*pi/N;
    ang2 = 0;
    Nx = N;
    layer_o = 1;
else
    ang = 2*pi/Nt_outer;
    ang2 = 2*pi/(N-Nt_outer);
    Nx = Nt_outer;
    layer_o = 2;
end

% Draw Outer Windings              
x0 = OD/2 + wg + isol + diameter; % Initial Winding Position for outer turns;  
k = 1;
for j = 1:layer_o
    if k>N
        break;
    end
    phi = 0;
    if j==2
        ang = ang2;
        phi = pi/Nt_outer;
    end
    for i = 1:Nx
        if k>N
            break;
        end
        x = (x0 + (j-1)*(diameter + 2*isol))*cos(ang*i+phi);
        y = (x0 + (j-1)*(diameter + 2*isol))*sin(ang*i+phi);
        diameterx = diameter*cos(ang*i+phi);
        diametery = diameter*sin(ang*i+phi);
        mi_drawarc(x,y,x-diameterx,y-diametery,180,10);
        mi_drawarc(x-diameterx,y-diametery,x,y,180,10);
        mi_addblocklabel(x-diameterx/2,y-diametery/2);
        mi_selectlabel(x-diameterx/2,y-diametery/2);
        mi_setblockprop(Core.CondMat, 1, 1, 'W1', 0, 2+i+(j-1)*Nt_outer, 1);
        mi_clearselected();
        k = k + 1;
    end
end

% Inner Windings
hw_i1 = 2*pi*(ID/2-wg-diameter/2-isol); % [m] largest window height for inner windings
Nt_i1 = floor(hw_i1/(diameter + 2*isol));
hw_i2 = 2*pi*(ID/2-wg-3*diameter/2-3*isol); % [m] largest window height for inner windings
Nt_i2 = floor(hw_i2/(diameter + 2*isol)); 

if (N<=Nt_i1)
    layer_i = 1;
    ang = 2*pi/N;
    ang2 = 0;
    Nx = N;
elseif (N >Nt_i1) && (N<=(Nt_i1+Nt_i2))
    layer_i = 2;
    ang = 2*pi/Nt_i1;
    ang2 = 2*pi/(N-Nt_i1);
    Nx = Nt_i1;
else
    fprintf('The maximum number of winding layers is 2!\n');            
end

% Draw Inner Windings              
x0 = ID/2 - wg - isol; % Initial Winding Position for outer turns;  
k = 1;
for j = 1:layer_i
    if k>N
        break;
    end
    phi = 0;
    if j==2
        ang = ang2;
        phi = pi/Nt_i1;
    end
    for i = 1:Nx
        if k>N
            break;
        end
        x = (x0 - (j-1)*(diameter + 2*isol))*cos(ang*i + phi);
        y = (x0 - (j-1)*(diameter + 2*isol))*sin(ang*i + phi);
        diameterx = diameter*cos(ang*i+phi);
        diametery = diameter*sin(ang*i+phi);
        mi_drawarc(x,y,x-diameterx,y-diametery,180,10);
        mi_drawarc(x-diameterx,y-diametery,x,y,180,10);
        mi_addblocklabel(x-diameterx/2,y-diametery/2);
        mi_selectlabel(x-diameterx/2,y-diametery/2);
        mi_setblockprop(Core.CondMat, 1, 1, 'W1', 0, 2+i+N+(j-1)*Nt_i1, -1);
        mi_clearselected();
        k = k + 1;
    end
end

% Litz Wire Complex Permeability & Conductivity %
%----------------------------------------------------------        
if Core.Winding.RoundWire_Stranded == 1
   % FEMM Definition of Litz Wire
    Core.LamType = 5;
    Core.complex_sigma = Core.sigma;
    Core.mu_Cond = 1;
    Core.Phi = 0;

elseif Core.Winding.RoundWire_Solid == 1
    % FEMM Definition of Solid Wire
    Core.complex_sigma = Core.sigma;
    Core.mu_Cond = 1;
    Core.LamType = 0;
    Core.n_strand = 1;
    Core.d_strand = 0;
    Core.Phi = 0;
end

%% Inductor Calculation
P_FEM(Harm_Numb)=0;
PlossW1(Harm_Numb)=0;
L1(Harm_Numb)=0;
Res_w(Harm_Numb)=0;
for j=1:Harm_Numb
    Core.F(j) = round(Ivec(j).f); % [Hz] Frequency
    I1 = Core.Ivec(j).AmpX; % [A]
    %I1 = Core.Ivec(j).AmpX.*exp(1i*Core.Ivec(j).Ph); % [A]
    mi_modifycircprop('W1', 1, I1); %mi_modifycircprop('W2', 1, -I1);

    % Modify Conductor Material Properties mainly in case of Litz Wire
    %----------------------------------------------------------
    mi_modifymaterial(Core.CondMat, 9, Core.LamType);
    mi_modifymaterial(Core.CondMat, 5, Core.complex_sigma/1e6);
    mi_modifymaterial(Core.CondMat, 1, Core.mu_Cond);
    mi_modifymaterial(Core.CondMat, 2, Core.mu_Cond);
    mi_modifymaterial(Core.CondMat, 10, Core.Phi);
    mi_modifymaterial(Core.CondMat, 11, Core.Phi);
    mi_modifymaterial(Core.CondMat, 12, Core.n_strand);

    % Parameters of the simulation
    %For highly refined meshes it may be necessary to reduce the minimum
    % angle to well below 20 to avoid problems associated with insufficient
    %floating-point precision. The edit box will accept values between 1 and 33.8 degrees.
    mi_setgrid(1.0000e-10,'cart'); %at most 0.01*1e-3 or low
    min_angle = 20;
    mi_probdef(Core.F(j),Core.unit,'planar',1e-9,HT,min_angle,0);
    mi_saveas([Core.modelname '.fem']);
    mi_zoomnatural;
    mi_analyze();
    mi_loadsolution();

    solutionW1 = mo_getcircuitproperties('W1');
    %solutionW2 = mo_getcircuitproperties('wdg 2');
    %solutionWx(1)= Total Current in peak
    %solutionWx(2)= Voltage Drop in peak
    %solutionWx(3)= Flux Linkage
    % L = solutionWx(3)/solutionWx(1)
    % R = solutionWx(2)/solutionWx(1)            
    L1(j) = abs(solutionW1(3)/solutionW1(1));
    %L2(j) = solutionW2(3)/solutionW2(1);

    % Power Loss Measured by Integration from FEMM, group block is
    % defined in the penultimum input of mi_setblockprop()
    mo_seteditmode('area');
    for i=1:2*N
        mo_groupselectblock(2+i);
        FEMM_m(i) = mo_blockintegral(6);
        mo_clearblock;
    end
    PlossW1(j) = sum(FEMM_m);
    lengthx = 2*HT;
    P_FEM(j)=(real(PlossW1(j)))/lengthx*MLT;
    Res_w(j)= real(solutionW1(2)/solutionW1(1))/lengthx*MLT;
end
Core.P_FEM = P_FEM;
Core.L_FEMM = L1;
Core.Pw_FEMM = sum(Core.P_FEM);
Core.MLT = MLT;
Core.Res_acBydc = sum(Core.P_FEM)/Core.P_FEM(1);  

end

