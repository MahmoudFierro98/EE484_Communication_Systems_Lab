%%
% Alexandria University
% Faculty of Engineering
% Electrical and Electronic Engineering Department
%
% Course: Communications System Lab.
% 
% Experiment 1: Bluetooth Protocol.

%%
clear;
close all;
clc;

%% Generate random bit sequence of length 1 ? 10^6 bits
M = 8;
N = log2(M);
N_bits  = N*ceil(10^(6)/N);
bit_seq = randi([0 1],1,N_bits);
Sym_seq = bi2de(flipud(reshape(bit_seq,N,[]))')';

%% Modulate the bit stream using 8DPSK
Zn = dpskmod(Sym_seq,M);

%% Add noise to the transmitted sequence -Demodulate the bit stream using 8DPSK - Compute BER 
SNR = 0:15;
BER = zeros(1,length(SNR));

for i = 1:length(SNR)
    % Add noise to the transmitted sequence
    rn = Zn + ((1/(2*sqrt(db2mag(SNR(i)*2))))*(randn(1,N_bits/N)+j*randn(1,N_bits/N)));
    % Demodulate the bit stream using 8DPSK
    Output_sym = dpskdemod(rn,M);
    Output_bit = reshape((fliplr(de2bi(Output_sym)))',1,[]);
    % Compute BER
    [error_bits_number,BER(i)] = biterr(bit_seq,Output_bit);
    %BER(i) = error_bits_number / N_bits;
end

%% Draw the probability of error curve
figure(1);
plot(SNR,BER,'linewidth',2);
title('BER vs. SNR','fontsize',10);
ylabel('BER','fontsize',10);
xlabel('SNR (dB)','fontsize',10);
figure(2);
semilogy(SNR,BER,'linewidth',2);
title('BER vs. SNR','fontsize',10);
ylabel('BER','fontsize',10);
xlabel('SNR (dB)','fontsize',10);
