clc; clear all; close all;
%% Initialization
Frames = 1000; %Number of Frames
fft_size = 128; %FFT Size (Number of subcarriers)
M = 16; K = log2(M); %16-QAM Modulation
delta = 312.5*10^(3); %Carrier Separation
delay_spread = 0.2*10^(-6); %Delay Spread
SNRdb = 0:3:30; %SNR Range in dB
delay_spread_max = delay_spread*fft_size*delta; %Number of paths
msg_size_bits = K*fft_size;
msg_size_symbols = msg_size_bits/K;
BER = zeros(length(SNRdb),Frames);
BER_avg = zeros(length(SNRdb),1);
%%
for i = 1:length(SNRdb)
for k = 1:Frames
%% Message Generation
msg_bits=randi([0,1],msg_size_symbols,K);
msg = bi2de(msg_bits,'left-msb')';
%% QAM Modulation 
X = qammod(msg,M,'UnitAveragePower',true);
%% IFFT
x = sqrt(fft_size).*ifft(X);
%% ADD Cyclic Prefix
CP = x(128-31:128);
msg_CP = [CP x];
%% Channel (fading + noise)
[fadedSamples, gain] =ApplyFading(msg_CP,1,delay_spread_max);
msg_rx=awgn(fadedSamples,SNRdb(i),'measured');
%% Cyclic prefix removal 
Y = msg_rx(33:160);
%% Freq domain equalization
Y_ = fft(Y)./sqrt(fft_size);
Z = Y_./fft(gain,128);                            
%% QAM Demodulation
msg_demod = qamdemod(Z,M,'UnitAveragePower',true);
msg_demod_bits  = de2bi(msg_demod,4,'left-msb');
%% BER calculation
[~,BER(i,k)] = biterr(msg_demod_bits,msg_bits);
BER_avg(i) = sum(BER(i,:))./Frames;
end
end
%% Plotting BER vs. SNR
figure
semilogy(SNRdb',BER_avg)
title('BER vs. SNR for 16-QAM with fading');
xlabel('SNR(dB)')
ylabel('BER')

