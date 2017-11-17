%% Housekeepingclear, clc; close all;%% Free-Free Beam Analytical Solution - results from matlab codeload free_free_beam_results.mat%% Creating H - copying H_matricies.m on 10/19/17 at 7pmload run_1.mat;[fft,freqH] = fft_func(data.x_sample,data.Nf);F(1,:,:) = fft(1,:,:);ZF = conj(F);for p = 1:10    for i = 1:5        X(i,:,p) = fft(i+1,:,p);        ZX = conj(X);    endendxPowFX = 0.1.*sum(ZF.*X,3);aPowFF = 0.1.*sum(ZF.*F,3);xPowXF = 0.1.*sum(ZX.*F,3);aPowXX = 0.1.*sum(ZX.*X,3);H1 = xPowFX./aPowFF;H2 = aPowXX./xPowXF;H_est = (H2 + H1)./2;coh = abs(H1./H2);H_est(:,ceil(data.Nf+1):end,:) = []; % truncates h matrixH = mean(H_est, 3); % averaging all trials to create H for quadrature%% Quadrature Code - copying quadrature draftn = size(H,2); % number of data points taken in H vectorfreq_range = data.Nf; % enter sampling frequency (Hz) - nyquist frequency for truncated datafreq_spacing = 1; % enter freqency spacing (Hz) from the FFT transformationfreq = [0:(freq_range)/(n-1):freq_range]; % sets a frequency vector (Hz) of correct length% 1. finding undamped natural frequencies by plotting Re[H] vs. omegaHreal=real(H); % find the real components of H% plot routine% figure(3)   % plot real components of H versus frequencies% plot(freq, Hreal);% title('Re component measured FRFs of a force applied to 2nd mass')% xlabel('frequency (Hz)'); ylabel('Re[H(\omega)]'); % no units given for Re[H(\omega)]% legend('H_1_2', 'H_2_2', 'H_3_2','H_4_2','H_5_2'); grid;% the natural frequencies must be well spaced for the quadrature method% this is not true because FRFs do not cross the freq axis at the same point% the natural frequency values were determined from figure(1)omega(1) = mean([92.5, 92.1, 92.4, 92.3, 92.3], 2); % units for omega are Hz from the plotomega(2) = mean([235.9, 235.9, 236.4, 235.9, 235.9], 2);omega(3) = mean([460.6, 460.6, 460.7, 460.6, 460.6], 2);% fprintf('here are the measured natural freqencies (Hz):')% disp(omega)% 2. finding damping ratios by the half-power point methodHimag = imag(H); % imaginary component of HHmag = sqrt(Hreal.^2.+Himag.^2); % magnitude of H% the frequencies must be partitioned out into 3 sections to plot linesspacing_bucket = [80, 100, 300, 500]; % enter the boundaries for each spacing bucket (Hz)freq1 = [spacing_bucket(1):1/spacing_bucket(2):spacing_bucket(2)]; % units here are still in Hzfreq2 = [spacing_bucket(2):1/(spacing_bucket(3)-spacing_bucket(2)):spacing_bucket(3)];freq3 = [spacing_bucket(3):1/(spacing_bucket(4)-spacing_bucket(3)):spacing_bucket(4)];% for each section, take the half-power point amplitudefor i = 1:5    for j = 1:3        hpp(i,j) = max(Hmag(i,(spacing_bucket(j)/freq_spacing+1):(spacing_bucket(j+1)/freq_spacing+1)))/sqrt(2);    endend%plot routine% figure(4) % plot magnitude of H versus frequencies% semilogy(freq,Hmag); hold on;% % plot(freq1,hpp(1,1)*ones(1,length(freq1))); % equations for hpp lines, this is not automated to allow easy enabling and disabling of plotted lines% % plot(freq2,hpp(1,2)*ones(1,length(freq2)));% % plot(freq3,hpp(1,3)*ones(1,length(freq3)));% % plot(freq1,hpp(2,1)*ones(1,length(freq1)));% % plot(freq2,hpp(2,2)*ones(1,length(freq2)));% % plot(freq3,hpp(2,3)*ones(1,length(freq3)));% % plot(freq1,hpp(3,1)*ones(1,length(freq1)));% % plot(freq2,hpp(3,2)*ones(1,length(freq2)));% % plot(freq3,hpp(3,3)*ones(1,length(freq3)));% % plot(freq1,hpp(4,1)*ones(1,length(freq1))); % 5 rows in the H matrix% % plot(freq2,hpp(4,2)*ones(1,length(freq2)));% % plot(freq3,hpp(4,3)*ones(1,length(freq3)));% % plot(freq1,hpp(5,1)*ones(1,length(freq1)));% % plot(freq2,hpp(5,2)*ones(1,length(freq2)));% % plot(freq3,hpp(5,3)*ones(1,length(freq3)));% title('Magnutude of measured FRFs of a force applied to 2nd mass')% xlabel('frequency (Hz)'); ylabel('H(\omega)'); % no units given for Re[H(\omega)]% legend('H_1_2', 'H_2_2', 'H_3_2', 'H_4_2', 'H_5_2', 'hpp11','hpp12','hpp13', ...%     'hpp21','hpp22','hpp23','hpp31','hpp32','hpp33','hpp41','hpp42','hpp42',...%     'hpp51','hpp52','hpp53'); grid; hold off; % all legend entries enabled for all lines if needed% since the natural frequencies aren't well spaced and since the damping ratios are a global value% the damping ratios at each natural frequency a determined from figure(2)% add zeroes for values that don't exist% this will turn the function zero and it wil not be averagedomegazeta(1,1,:) = [91.0, 93.2];omegazeta(1,2,:) = [235.8, 236.5];omegazeta(1,3,:) = [460.1, 460.9];omegazeta(2,1,:) = [91.8, 94.0];omegazeta(2,2,:) = [235.8, 236.5];omegazeta(2,3,:) = [460.0, 460.9];omegazeta(3,1,:) = [91.4, 93.6];omegazeta(3,2,:) = [235.5, 236.4];omegazeta(3,3,:) = [460.0, 460.9];omegazeta(4,1,:) = [91.4, 93.7];omegazeta(4,2,:) = [235.8, 236.5];omegazeta(4,3,:) = [460.1, 460.9];omegazeta(5,1,:) = [91.3, 93.5];omegazeta(5,2,:) = [235.8, 236.5];omegazeta(5,3,:) = [460.0, 460.9];for i = 1:5 % calculating possible zeta values    for j = 1:3        zetar(i,j,1) = sqrt(1/2 + sqrt(1 - (((omegazeta(i,j,1)^2 - omegazeta(i,j,2)^2)/omega(j)^2)^2)/4)/2);        zetar(i,j,2) = sqrt(1/2 - sqrt(1 - (((omegazeta(i,j,1)^2 - omegazeta(i,j,2)^2)/omega(j)^2)^2)/4)/2);    endendfor i = 1:5 % rewriting averaging function into a general case to eliminate bad values    for j = 1:3        for k = 1:2 % positive and negative value only            if zetar(i,j,k)<0.7 % assuming smaller value is good                zetaverage(i,j) = zetar(i,j,k);            else                zetaverage(i,j) = 0;            end        end    endendfor i = 1:3 % averaging zeta values for final result    zeta(i) = mean(nonzeros(zetaverage(:,i)));end% fprintf('here are the measured damping ratios:')% disp(zeta)% 3. finding the mode shapes by plotting Im[H] vs. omega, and modal masses% plot routine% figure(5)   % plot real components of H versus frequencies% plot(freq, Himag);% for i = 1:3%     line([omega(i) omega(i)], [-60 60]); % vertical lines at each natural frequency% end% title('Imag component measured FRFs of a force applied to 2nd mass')% xlabel('frequency (rad/s)'); ylabel('Im[H(\omega)]'); % no units given for Im[H(\omega)]% legend('H_1_2', 'H_2_2', 'H_3_2', 'H_4_2', 'H_5_2'); grid;% the unscaled magnitudes of Himag at the natural frequencies were determined from figure(3)% remember to check the magnitude of this function hereHimag1 = [ 1.43 ,  26.4  ,  50.6];Himag2 = [-0.298, -17.6  , -36.5];Himag3 = [-1.14 ,   0.421,  42.6];Himag4 = [-0.294,  18.7   , -36.9];Himag5 = [ 1.43 , -26.6  ,  50.7];Hmode = [Himag1; Himag2; Himag3; Himag4; Himag5];% Ar, the residue matrix can be calculated since zeta, omega, and FRF magnutides are known% Ar is only calculated for measured modes, and is formatted accordinglyfor i = 1:5    for r = 1:3        Ar(i,r) = -2*zeta(r)*(omega(r)*2*pi)^2.*Hmode(i,r);    endendu_measured(1,1:3) = 1; % scaling assumptionfor r = 1:3    m(r) = 1/Ar(1,r); % modal masses can be calculated here assuming response x1=1    for i = 2:5        u_measured(i,r) = Ar(i,r).*m(r)./u_measured(1,r); % the rest of the u matrix can also be calculated    endend% fprintf('here are the measured modal masses (assuming x1=1):')% disp(m)%plot routine% figure(6)   % plot real components of H versus frequencies% for j = 1:3%     plot(1:5, u_measured(:,j)); hold on% end% title('Mode shapes at each natural frequency/damping ratio')% xlabel('location'); ylabel('relative intensity'); set(gca,'XTick',0:5);% ylim([-1 1]);% legend('mode shape 1', 'mode shape 2', 'mode shape 3'); grid; hold off;% disp('measured mode shapes are plotted on figure (4)')% %% Synthesized Frequency Response Functions% % Much of this code is adapated from the% % superposition_freq_domain_altered.m class example% % Ar(:,:,2) = Ar; % properly setting the residue matrix% Ar(:,:,1) = 0;% % FRF matrix synthesis% for cc1 = 1:length(freqH)%     for i = 1:5%         for r = 1:3%             for j = 1:5%                A(i,r,j) = u_measured(i,r)*u_measured(j,r).'/m(r);%                H_h(i,r,j,cc1) = A(i,r,j)./(omega(r)^2 - (2*pi*freqH(cc1))^2 + 2*1i*zetar(r)*omega(r)*2*pi*freqH(cc1));%             end%         end%     end% end% % HT = squeeze(sum(H_h,3)); % superimpose modes => total "measured" FRF matrix% % for i = 1:5%     for j = 1:5%         for r = 1:3%             H_plot  = squeeze(H_h(i,r,:,:));%             HT_synth_helper1 = squeeze(HT(i,j,:));%             HT_synth_helper2 = transpose(HT_synth_helper1);%             HT_synth (i,:,r) = HT_synth_helper2;%         end%     end% end% % % delete this plot routine later% for pm = 1:5 % plotting synthesized FRFs with measured data - magnitude and phase%     figure()%     subplot(2,1,1);%     plot(abs(HT_synth(pm,:,2))); hold on%     title(['Sensor Location ' num2str(pm) ' Responses'])%     xlabel('Frequency (Hz)'); ylabel('|H|');%     subplot(2,1,2);%     plot(freqH, atan2(-imag(HT_synth(pm,:,2)), real(HT_synth(pm,:,2)))*180/pi);%     xlabel('Frequency (Hz)'); ylabel('Phase (deg)');%     hold off% end%% Comparing Analytical and Measured methods - Creating the output plots% percent errors between analytical and measured natural frequenciesfprintf('here are the analytical natrual frequencies (Hz):')disp(fr)fprintf('here are the measured natural freqencies (Hz):')disp(omega)error = 100*abs(fr-omega)./mean(omega,1);fprintf('the percent error (in percent) between the two methods for each natural frequency is:')disp(error)fprintf('here are the measured damping ratios')disp(zeta)% for i = 1:3 % mode shape plots%     figure();%     plot(1:5, u_measured(:,i)); hold on % measured mode shape%     plot(1:4/(length(u_analytical)-1):5, u_analytical(i,:)); % analytical mode shape%     % title(['Sensor Location ' num2str(i) ' Mode Shape'])%     xlabel('Location'); ylabel('Relative Intensity'); set(gca,'XTick',0:5);%     ylim([-1 1]);%     legend('Measured', 'Analytical'); grid; hold off;% end% disp('mode shape plots have been created');for pl = 1:5 % plotting coherence and FRFs    figure()    subplot(2,1,1);    plot(freqH,abs(X(pl,:,1))); hold on    title(['Sensor Location ' num2str(pl) ' Response'])    xlabel('Frequency (Hz)'); ylabel('|H|');    subplot(2,1,2);    plot(freqH,coh(pl,:));    xlabel('Frequency (Hz)'); ylabel('Coherence');    hold offenddisp('FRF and coherence plots have been created')% % for pm = 1:5 % plotting synthesized FRFs with measured data - magnitude and phase%     figure()%     subplot(2,1,1);%     plot(freqH,abs(X(pm,:,1))); hold on%     plot(freqH,abs(HT_synth(pm,:,2)));%     title(['Sensor Location ' num2str(pm) ' Responses'])%     xlabel('Frequency (Hz)'); ylabel('|H|');%     legend('Measured', ' Synthesized');%     subplot(2,1,2);%     plot(freqH, atan2(-imag(HT_synth(pm,:,2)), real(HT_synth(pm,:,2)))*180/pi);%     xlabel('Frequency (Hz)'); ylabel('Phase (deg)');%     hold off% end% % for i = 1:5 % plotting synthesized FRFs with measured data - magnitude and phase%     for k = 1:3%         figure()%         subplot(2,1,1);%         plot(freqH,abs(HT_synth(i,:,2)));%         title(['Force Location ' num2str(k) ' Sensor Location ' num2str(i) ' Responses'])%         xlabel('Frequency (Hz)'); ylabel('|H|');%         subplot(2,1,2);%         plot(freqH, atan2(-imag(HT_synth(i,:,k)), real(HT_synth(i,:,k)))*180/pi);%         xlabel('Frequency (Hz)'); ylabel('Phase (deg)');%         hold off%     end% end