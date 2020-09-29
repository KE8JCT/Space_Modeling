%%
%Auroral Propagation

N = [3e5 2e5; 1.5e6 8e3]; %electron density in electrons/m^3, Rows = Layer (E or F), Columns = Night/Day
nu = [6e3 6e3; 2e5 2e5]; %collision frequency between electrons and neutrals
f = 30e6:1e6:300e6;% frequency, hertz



K_E(1,:) = 1.15e-3 .* N(1,1) .* nu(1,1) ./ f.^2 ; %absorption coefficient, dB/Km
K_E(2,:) = 1.15e-3 .* N(1,2) .* nu(1,2) ./ f.^2 ; %absorption coefficient, dB/Km
K_F(1,:) = 1.15e-3 .* N(2,1) .* nu(2,1) ./ f.^2 ; %absorption coefficient, dB/Km
K_F(2,:) = 1.15e-3 .* N(2,2) .* nu(2,2) ./ f.^2 ; %absorption coefficient, dB/Km
%{
semilogy(f,K_E(1,:), '-r')
hold on
semilogy(f,K_E(2,:), '--r')
semilogy(f,K_F(1,:), '-b')
semilogy(f,K_F(2,:), '--b')
title('E- and F-layer Auroral Loss for day and night over VHF frequency range')
legend('E-Layer Day','E-Layer Night','F-Layer Day','F-Layer Night')
xlabel('Frequency (Hz)')
ylabel('specific loss km/dB')
hold off
%}
%%
%EME Path Loss from Princeton publication

%this could be cool. model lambda as air, then different coeffecients as
%raised in atmosphere; piecewise

ada = .065; %lunar reflection coefficient
r_moon = 1.738e6; %radius of moon (constant)
d = [356500e3 406700e3]; %distance to the moon
f = 144e6:10e6:47e9; %freq
lambda = 2.9979e8 ./ f ;
eme_loss_L = zeros(2,length(lambda));
for i = 1:length(lambda)
eme_loss = (ada.*r_moon.^2.*lambda(i).^2) ./ (64.*pi.^2.*d.^4); %eme path loss (ratio)
eme_loss_L(:,i) = 10 * log10(eme_loss); %log scale for path loss
end
semilogy(lambda, eme_loss_L(1,:), 'g')
hold on
semilogy(lambda, eme_loss_L(2,:), 'c')
xlabel('Wavelength (m)')
ylabel('Loss (dB)')
legend('Moon at Perigee','Moon at Apogee')
title('EME Path Loss and wavelength for Perigee and Apogee')
hold off
%%

%Book - Meteor at VHF levels
lambda = 1:20; %wavelengh in VHF- upper HF range
r_e = 2.8178e-15; %radius of electron
R = 400e3; %distance to trail
qunder = .5e14; %electron line density of trail
qover = 5e14
D = 1:140; %Diffusion coefficent, m^2/s
t = 10; %time measured from formation of trail (40 km/s)


g_t = 20; %isotropic=1, transmitter gain
g_r = 20; %isotropic=1, receiver gain
%{
for i=1:length(D)
scattering_cross_qunder = ((sqrt(R.*lambda ./ (2.*r_e.*qunder))).^2) .^(-32*pi^2*D(i) ./ (lambda.^2)*t) ;
power_ratio_qunder = 10*log10(g_t.*g_r.*lambda.^2 ./ (16*pi^2*R^4) .* scattering_cross_qunder )

scattering_cross_qover = ((sqrt(R.*lambda ./ (2.*r_e.*qover))).^2) .^(-32*pi^2*D(i) ./ (lambda.^2)*t) ;
power_ratio_qover = 10*log10(g_t.*g_r.*lambda.^2 ./ (16*pi^2*R^4) .* scattering_cross_qover) 
if i==1
semilogy(lambda,power_ratio_qover, 'r')
hold on
semilogy(lambda,power_ratio_qunder, 'b')
else
semilogy(lambda,power_ratio_qover, '--r')
semilogy(lambda,power_ratio_qunder, '--b') 
end
end

title('Gain for Wavelengths over meteor scatter observations with increasing D')
xlabel('wavelength (m)')
ylabel('gain (dB)')
legend('Overdense trail','Underdense Trail')
hold off
%}
%%
%Sporadic E, if it can be characterized
%it cant
