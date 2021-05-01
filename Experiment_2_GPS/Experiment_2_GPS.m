%%
% Alexandria University
% Faculty of Engineering
% Electrical and Electronic Engineering Department
%
% Course: Communication Systems Lab.
% 
% Experiment 2: GPS (GNSS Protocol).

%%
clear;
close all;
clc;

%% Generate G1
n_bits  = 10;
chips   = 2^(n_bits)-1;
x_axis  = 0:1:(chips-1);
bit_seq = ones(1,n_bits);
G1      = zeros(1,chips);
for i = 1:chips
    G1(1,i)      = bit_seq(1,10);
    new_value    = bitxor(bit_seq(1,10),bit_seq(1,3));
    bit_seq      = circshift(bit_seq',1)';
    bit_seq(1,1) = new_value;
end

%% A. For phase tap (3,8)
bit_seq = ones(1,n_bits);
G2_38pt = zeros(1,chips);
C_A_1   = zeros(1,chips);
% Generate G2 phase tap (3,8)
for i = 1:chips
    G2_38pt(1,i) = bitxor(bit_seq(1,8),bit_seq(1,3));
    new_value    = bitxor(bit_seq(1,10),bitxor(bit_seq(1,9),bitxor(bit_seq(1,8),bitxor(bit_seq(1,6),bitxor(bit_seq(1,3),bit_seq(1,2))))));
    bit_seq      = circshift(bit_seq',1)';
    bit_seq(1,1) = new_value;
end
% Generate C/A Code
for i = 1:chips
    C_A_1(1,i) = bitxor(G1(1,i),G2_38pt(1,i));
end
% Plot
C_A_1 = 2*C_A_1-1;
for i = 0:1:(chips-1)
    C_A_1_sh     = circshift(C_A_1',[i,0]);
    output1(i+1) = C_A_1 * C_A_1_sh;
end
figure('Name','Autocorrelation For phase tap (3,8)');
stem(x_axis,output1);
title('Autocorrelation For phase tap (3,8)');

%% B. Change the phase taps to (2, 6)
bit_seq = ones(1,n_bits);
G2_26pt = zeros(1,chips);
C_A_2   = zeros(1,chips);
% Generate G2 phase tap (3,8)
for i = 1:chips
    G2_26pt(1,i) = bitxor(bit_seq(1,6),bit_seq(1,2));
    new_value    = bitxor(bit_seq(1,10),bitxor(bit_seq(1,9),bitxor(bit_seq(1,8),bitxor(bit_seq(1,6),bitxor(bit_seq(1,3),bit_seq(1,2))))));
    bit_seq      = circshift(bit_seq',1)';
    bit_seq(1,1) = new_value;
end
% Generate C/A Code
for i = 1:chips
    C_A_2(1,i) = bitxor(G1(1,i),G2_26pt(1,i));
end
% Plot
C_A_2 = 2*C_A_2-1;
for i = 0:1:(chips-1)
    C_A_2_sh   = circshift(C_A_2',[i,0]);
    output2(i+1) = C_A_2 * C_A_2_sh;
end
figure('Name','Autocorrelation For phase tap (2,6)');
stem(x_axis,output2);
title('Autocorrelation For phase tap (2,6)');

%% C. Cross-correlation
for i = 0:1:(chips-1)
    C_A_1_sh   = circshift(C_A_1',[i,0]);
    output3(i+1) = C_A_2 * C_A_1_sh;
end
figure('Name','Cross-correlation');
stem(x_axis,output3);
title('Cross-correlation');
