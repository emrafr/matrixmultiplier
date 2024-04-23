clear all
close all
clc

% input matrix
X_row = 4;
X_col = 8;

% Coefficient matrix
A_row = 8;
A_col = 4;

%% constant coefficients, do not change
%hardcode the coefficients and write to RomCoeff.txt
A = [3,8,18,1; 22, 15, 40, 10; 11,2,3,4; 1,4,2,0; 8,12,16,2; 3,6,9,12; 1,1,1,1 ; 2,2,2,2 ];
AW = 7;
A_fi = fi(A, 0, AW, 0);

fid = fopen('./mem/RomCoeff.txt', 'w');
for iC = 1:A_col
    for iR = 1:2:A_row
        temp_fi1 = A_fi(iR,iC);
        iR = iR + 1;
        temp_fi2 = A_fi(iR,iC);
        fprintf(fid, '%s%s\n', temp_fi1.bin, temp_fi2.bin);
    end
end
temp_fi = fi(0, 0, AW, 0);
for iC = A_col:512
    fprintf(fid, '%s%s\n', temp_fi.bin, temp_fi.bin);
end



%% Randomly generate stimuli X matrix
% fid path for input_stimuli.txt
fid = fopen('./input_stimuli.txt', 'w');

%wordlength
X_W = 8;
% pick numbers randomly in the dynamic range
NUM_MATRIX = 5;

X = rand(X_row, X_col, NUM_MATRIX)*(2^(X_W-1)-1);
X_fi = fi(X,1,X_W, 0);
for iN = 1:NUM_MATRIX
    for iC = 1:X_col
        for iR = 1:X_row
        temp_fi1 = X_fi(iR, iC, iN);
        fprintf(fid, '%s\n', temp_fi1.bin);
        end
    end
end

%% generate results and expected outputs

% write results to output_stimuli.txt
fid = fopen('./output_results.txt', 'w');
fid_hr = fopen('./output_results_readable.txt', 'w');
% 18bits wide RAM
P_W = 18;
for iN = 1:NUM_MATRIX

    X_temp = squeeze(X_fi(:,:,iN));
    P = X_temp*A;
    P = fi(P,1,P_W, 0);
    for iC = 1:A_col
        for iR = 1:A_col
            temp_fi1 = P(iR, iC);
            fprintf(fid, '%s\n', temp_fi1.bin);
        end
    end

    display(sprintf('Results for matrix P(%d)', iN));
    tmp_str = sprintf('Results for matrix P(%d)', iN);
    %display(tmp_str);
    fprintf(fid_hr, '%s\n',tmp_str);
    fprintf(fid_hr, '%d\n', double(P));

    mean_diag = mean(diag(double(P)));
    display(sprintf('Average value of diagonal elements of matrix = %d', double(mean_diag) ));
    tmp_str = sprintf('Average value of diagonal elements of matrix = %d', double(mean_diag) );
    fprintf(fid_hr, '%s\n',tmp_str);

    P_max = max(max(P));
    display(sprintf('Maximum value in matrix = %d, hex(0x%s)', double(P_max),  P_max.hex ));
    tmp_str = sprintf('Maximum value in matrix = %d, hex(0x%s)', double(P_max),  P_max.hex );
    %display(tmp_str);
    fprintf(fid_hr, '%s\n',tmp_str);

    display('*********');
    fprintf(fid_hr, '*********\n');
end
