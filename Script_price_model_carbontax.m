 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  Whole World %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  price´´s model  %%%%%%%%%%%%%%%%%%%

% Price model India with exogeneous price increase for fossil fuels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Chose region
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1= 'AT'	2='BE'	3= 'BG'	4='CY'	5= 'CZ'	6='DE'	7='DK'	8='EE'	9='ES'	10='FI'	11='FR'	12='GR'	13='HR'	14='HU'	15='IE'	16='IT'	17='LT'	18='LU'	19='LV'	20='MT'	21='NL'	22='PL'	23='PT'	24='RO'	25='SE'	26='SI'	27='SK'	28='GB'	29='US'	30='JP'	31='CN'	32='CA'	33='KR'	 region='BR'	35='IN'	36='MX'	37='RU'	38='AU'	39='CH'	40='TR'	41='TW'	42='NO'	43='ID'	44='ZA'	45= 'WA'	46='WL'	46='WE'	48='WF'	49='WM'
 % Preismodel Indonesia with exogeneous price increase for fossil fuels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
countrynumber=35;
countrynumber=countrynumber-1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%compute relative increase in wsk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
taxrate=5; % in USD per ton of CO2 --> choose tax rate, i.e. USD 40 per ton
CO2emissions=sateliteaccounts(15,:);
CO2expenses=CO2emissions*taxrate*(1/1000000000); % in mill €
% taxmultiplier(isnan(taxmultiplier))= 0;
for j=1:length(VA_har2);
    if(VA_har2(j)>0);
    taxmultiplier(j)=(VA_har2(j)+CO2expenses(j))*(1/VA_har2(j));
    else
     taxmultiplier(j)=1;   
    
%     if taxmultiplier(j)==0;
%         taxmultiplier(j)=1;
    end
end

for j=1:n*countrynumber;
    taxmultiplier(j)=1;
end
for j=(n*countrynumber+n):9800;
    taxmultiplier(j)=1;
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%run price model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=A_har2; %A_har is the harmonized A matrix
totalwsk=WSK_har2;
A1=A;%
L1=(eye(length(A1))-A1);
C1=L1\eye(length(A1));
results2=C1'*((taxmultiplier.*totalwsk)');
% 
cd('D:\Doku\Diss\MCC Berlin\2 India IO\3_Arbeitspakete\Matlab Results')
xlswrite('Results_price_model_case5c.xlsx',{'product number','product','relative price'},'5_USD_per_ton','A1')
xlswrite('Results_price_model_case5c.xlsx',(1:n)','5_USD_per_ton','A2')
xlswrite('Results_price_model_case5c.xlsx',product_id,'5_USD_per_ton','B2')
xlswrite('Results_price_model_case5c.xlsx',results2(n*countrynumber+1:n*countrynumber+200),'5_USD_per_ton','C2')

winopen('Results_price_model_case5c.xlsx');



