function [ Converter ] = Compare_Waveforms( Converter ) 
    figure;
    plot(Converter.Wav.thetaA)

    figure;
    plot(Converter.Wav.IgA)
    title('Marco - IgA')
    grid on

    IgA_rms=rms(Converter.Wav.IgA)
    IgA_mean=mean(Converter.Wav.IgA)
    IgA_max=max(Converter.Wav.IgA)
    IgA_min=min(Converter.Wav.IgA)

    figure;
    plot(Converter.Wav.D_iLpha)
    title('Marco - D_iLpha')
    grid on

    D_iLpha_rms=rms(Converter.Wav.D_iLpha)
    D_iLpha_mean=mean(Converter.Wav.D_iLpha)
    D_iLpha_max=max(Converter.Wav.D_iLpha)
    D_iLpha_min=min(Converter.Wav.D_iLpha)

    figure;
    plot(Converter.Wav.iLA)
    title('Marco - iLA')
    grid on

    iLA_rms=rms(Converter.Wav.iLA)
    iLA_mean=mean(Converter.Wav.iLA)
    iLA_max=max(Converter.Wav.iLA)
    iLA_min=min(Converter.Wav.iLA)


    figure;
    plot(Converter.Wav.B_fluxA)
    title('Marco - B_fluxA')
    grid on

    B_fluxA_rms=rms(Converter.Wav.B_fluxA)
    B_fluxA_mean=mean(Converter.Wav.B_fluxA)
    B_fluxA_max=max(Converter.Wav.B_fluxA)
    B_fluxA_min=min(Converter.Wav.B_fluxA)
    
%     figure;
%     plot(Converter.Wav.L)
%     title('Marco - L1')
%     grid on
    
end