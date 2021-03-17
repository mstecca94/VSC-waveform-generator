% Author: Thiago Soeiro
% Date of Last Update: 13.07.2013
classdef winding_loss
    %WINDING_LOSS     
    properties
    end
    
    methods(Static)
                
          function [FR, GR, RDC] = round_conductor(sigma, d, f) %sigma: conductance, d: Diameter, f: Frequency
                u0=4*pi*1e-7;
                delta = 1/sqrt(pi*u0*sigma*f); 
                chi=d/( sqrt(2) * delta );
                                
                RDC = 4/(sigma*d^2*pi); 
               
                FR = chi/(4*sqrt(2))*((winding_loss.KelvinBer(0,chi)*winding_loss.KelvinBei(1,chi)-winding_loss.KelvinBer(0,chi)*winding_loss.KelvinBer(1,chi))/(winding_loss.KelvinBer(1,chi)^2+winding_loss.KelvinBei(1,chi)^2)-(winding_loss.KelvinBei(0,chi)*winding_loss.KelvinBer(1,chi)+winding_loss.KelvinBei(0,chi)*winding_loss.KelvinBei(1,chi))/(winding_loss.KelvinBer(1,chi)^2+winding_loss.KelvinBei(1,chi)^2));
                % FR = 0.5*chi*( (exp(2*chi)-exp(-2*chi) + 2*sin(2*chi))/(exp(2*chi)+exp(-2*chi) - 2*cos(2*chi))  ); 
                GR = -chi*pi^2*d^2/(2*sqrt(2))*((winding_loss.KelvinBer(2,chi)*winding_loss.KelvinBer(1,chi)+winding_loss.KelvinBer(2,chi)*winding_loss.KelvinBei(1,chi))/(winding_loss.KelvinBer(0,chi)^2+winding_loss.KelvinBei(0,chi)^2)+(winding_loss.KelvinBei(2,chi)*winding_loss.KelvinBei(1,chi)-winding_loss.KelvinBei(2,chi)*winding_loss.KelvinBer(1,chi))/(winding_loss.KelvinBer(0,chi)^2+winding_loss.KelvinBei(0,chi)^2));
                % Equations should agree, give the same result as Maple file.
          end
          
          function [FF, GF, RDC] = foil_conductor(sigma, h, b, f) %sigma: conductance, d: Heigth of the Foil, b: width of the foil, f: Frequency 
                u0 = 4*pi*1e-7;
                delta = 1/sqrt(pi*u0*sigma*f); 
                v = h/delta;
                
                RDC = 1/(sigma*b*h); 
                
                FF = v/4 * (sinh(v)+sin(v))/(cosh(v)-cos(v));
                GF = b^2 * v * (sinh(v)-sin(v))/(cosh(v)+cos(v));   
                % Equations are not controlled.
          end
          
          function out = KelvinBer(v,x) % Functions were compared with Maple!      
                out = (1/2) * ( besselj(v, x*exp(3*1i*pi/4) ) + besselj(v,x*exp(-3*1i*pi/4) ) );
          end
          
          function out = KelvinBei(v,x) % Functions were compared with Maple!
                out =  1/(2*1i) * ( besselj(v, x*exp(3*1i*pi/4) ) - besselj(v,x*exp(-3*1i*pi/4) ) );
          end

    end
    
end

