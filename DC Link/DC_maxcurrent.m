function [ Wave ] = DC_maxcurrent ( Wave )

x=1;
step_M = abs(Wave.Input.Vdcmax-Wave.Input.Vdcmin)/10;

for vdc = Wave.Input.Vdcmin:step_M:Wave.Input.Vdcmax % 10 voltage variations
    for vll=400*(1-Wave.Input.grid_v_variation):50:400*(1+Wave.Input.grid_v_variation)
        M_range(x,:) = 2*vll*sqrt(2/3)/vdc ;
        vdc_range(x,:) = vdc ;
        vll_range(x,:) = vll ;
        I_range(x,:) = Wave.Input.P/sqrt(3)/vll;
        x=x+1;
    end
end

%%

if Wave.Input.phimax==Wave.Input.phimin
    for y = 1:size(M_range,1)
        %%
        clear DC_Design
        DC_Design.M=M_range(y);
        DC_Design.vdc=vdc_range(y);
        DC_Design.I=I_range(y);
        DC_Design.phi=Wave.Input.phi;
        % generate voltage
        [ Wave , DC_Design ] = arm_voltage_DC ( Wave , DC_Design ) ;

        % fft of the voltage
        [ Wave , DC_Design ] = volt_fft_DC ( Wave , DC_Design ) ;  

        % define AC ripple in the current
        [ Wave , DC_Design ] = current_with_ripple_DC ( Wave , DC_Design ) ;

        % find rms DC current   
        [ Wave , DC_Design ] = DC_link_current_DC ( Wave , DC_Design ) ;

        I_dc_cap(y) = DC_Design.i_DC_cap_rms ;
        I_dc(y) = DC_Design.i_DC_rms ;
        y=y+1;
    end
    %% Plot data
    if Wave.Input.Plot_DC_link_Current == 1 
        figure;
        subplot(1,2,1)
        plot(M_range,I_dc)
        title('DC link current')
        xlabel('Modulation index')
        ylabel('I [A]')
        grid on

        subplot(1,2,2)
        plot(M_range,I_dc_cap)
        title('DC link capacitor current')
        xlabel('Modulation index')
        ylabel('I[A]')
        grid on
    end    
else
    step_phi = abs(Wave.Input.phimax-Wave.Input.phimin)/10;
    x=1;
    phi_range=Wave.Input.phimin:step_phi:Wave.Input.phimax;
    for phi_DC = 1:size(phi_range,2)
        for y = 1:size(M_range,1)
            %%
            clear DC_Design
            DC_Design.M=M_range(y);
            DC_Design.vdc=vdc_range(y);
            DC_Design.I=I_range(y);
            DC_Design.phi=phi_range(x);
            % generate voltage
            [ Wave , DC_Design ] = arm_voltage_DC ( Wave , DC_Design ) ;

            % fft of the voltage
            [ Wave , DC_Design ] = volt_fft_DC ( Wave , DC_Design ) ;  

            % define AC ripple in the current
            [ Wave , DC_Design ] = current_with_ripple_DC ( Wave , DC_Design ) ;

            % find rms DC current   
            [ Wave , DC_Design ] = DC_link_current_DC ( Wave , DC_Design ) ;

            I_dc_cap(x,y) = DC_Design.i_DC_cap_rms ;
            I_dc(x,y) = DC_Design.i_DC_rms ;
            y=y+1;
        end
        x=x+1;
    end
    %% Plot data
    if Wave.Input.Plot_DC_link_Current == 1 
        [X,Y]=meshgrid(M_range,phi_range/pi*180);
        figure;
        subplot(1,2,1)
        surf(X,Y,I_dc)
        title('DC link current')
        xlabel('Modulation index')
        ylabel('Phase shift [deg]')
        zlabel('I [A]')
        grid on
        colormap(jet)

        subplot(1,2,2)
        surf(X,Y,I_dc_cap)
        title('DC link capacitor current')
        xlabel('Modulation index')
        ylabel('Phase shift [deg]')
        zlabel('I[A]')
        grid on
        colormap(jet)
    end

end

%% Save data

Wave.DClink.M_range = M_range ;
Wave.DClink.I_dc = I_dc ;
Wave.DClink.I_dc_cap = I_dc_cap ;
Wave.DClink.I_dc_max = max(I_dc,[],'all') ;
Wave.DClink.I_dc_cap_max = max(I_dc_cap,[],'all') ;

end