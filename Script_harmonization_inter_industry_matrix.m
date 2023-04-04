%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Proportional harmonization of EXIO with Energy Statistics  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Chose region
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1= 'AT'	2='BE'	3= 'BG'	4='CY'	5= 'CZ'	6='DE'	7='DK'	8='EE'	9='ES'	10='FI'	11='FR'	12='GR'	13='HR'	14='HU'	15='IE'	16='IT'	17='LT'	18='LU'	19='LV'	20='MT'	21='NL'	22='PL'	23='PT'	24='RO'	25='SE'	26='SI'	27='SK'	28='GB'	29='US'	30='JP'	31='CN'	32='CA'	33='KR'	 region='BR'	35='IN'	36='MX'	37='RU'	38='AU'	39='CH'	40='TR'	41='TW'	42='NO'	43='ID'	44='ZA'	45= 'WA'	46='WL'	46='WE'	48='WF'	49='WM'
region=35
region=region-1; %Correction of Zero-One;
n=200
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




cd('D:\Doku\Diss\MCC Berlin\2 India IO\3_Arbeitspakete\Matlab Results')
[num,txt]=xlsread('coal_shares_input.xlsx');
K=num;
balancing=3623.52    %Balancing is the balancing value that is added to the sector of scope and proportionally substracted from the other sectors
remainder=balancing; % Remainder is the remainder value to account for rounding mistakes
Z_har2=Z; %Z_har2 is the new matrix
VA_har2=totalVA; %VA_har2 is the new value added 

Z_har2(n*region+22,n*region+128)= Z(n*region+22,n*region+128)+balancing; 
VA_har2(n*region+128)=totalVA(n*region+128)-balancing;

for j=1:length(K)
Z_har2(n*region+22,K(j,1))= Z(n*region+22,K(j,1))-balancing*K(j,6);       
VA_har2(K(j,1))=totalVA(K(j,1))+balancing*K(j,6);
j
remainder=remainder-balancing*K(j,6)
end
Z_har2(n*region+22,n*region+128)= Z_har2(n*region+22,n*region+128)-remainder; 
VA_har2(n*region+128)=VA_har2(n*region+128)+remainder;



% compute new wsk  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:length(A)
    if BPW(j)>0
    WSK_har2(j)=(1/BPW(j))*VA_har2(:,j);
    else 
    WSK_har2(j)=0*VA_har2(:,j);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% compute new A matrix %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:length(A);
    if BPW(j)>0
    A_har2(:,j)=Z_har2(:,j)*(1/BPW(j));
    else
    A_har2(:,j)=Z_har2(:,j)*0;   
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute new C Matrix %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L_har2=(eye(length(A))-A_har2);
C_har2=L_har2\eye(length(A_har2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Overwrite Variables %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L=L_har2;
% clear L_har2;
% Z=Z_har2;
% clear Z_har2;
% C=C_har2;
% clear C_har2;
% A=A_har2;
% clear A_har2;
% totalVA=VA_har2;
% totalwsk=WSK_har2;
% clear WSK_har2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AAAAA_harmonizationcode_ran=1



