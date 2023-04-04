% clear all
close all
cd('C:\Users\orj\Documents\MCC Berlin\2 India IO\5_Quellen\EXIO\exiobase3.4_iot_2011_pxp\IOT_2011_pxp')
n=200; %n= number of products or sectors

% Input final demand FD, and value added components VA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y=dlmread('Y.txt','\t',3,2);
FD=Y;
total_FD=sum(FD,2);
F=dlmread('F.txt','\t',2,1);
VA=F(1:9,:);
sateliteaccounts=F(10:1104,:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input A Matrix, Compute Leontief Inverse C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = dlmread('A.txt','\t',3,2);
L=(eye(length(A))-A);
C=L\eye(length(A));
BPW=C*(total_FD);

%BPW_ID=BPW(n*42+1:n*42+n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Compute value added coefficients wsk and satelite coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WSK=0*VA;
satelite=0*sateliteaccounts;
for j=1:length(A)
    if BPW(j)>0
    WSK(:,j)=(1/BPW(j))*VA(:,j);
    satelite(:,j)=(1/BPW(j))*sateliteaccounts(:,j);
    else 
    WSK(:,j)=0*VA(:,j);
    satelite(:,j)=0*sateliteaccounts(:,j);

    end
end

totalwsk=sum(WSK);
totalVA=sum(VA);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Read country and product labels %%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[num,raw,txt]=xlsread('A_labels.xlsx');
country_world_id=txt(:,1);
product_world_id=txt(:,2);
product_id=txt(1:n,2);
counter=1;
for i=1:n:length(raw)
        country_id(counter)=raw(i);
    counter=counter+1;
end

 product_world_id2=(1:200)';
 for j=1:(49-1)
 product_world_id2=vertcat([(1:200)'],[product_world_id2]); % Shows 
 end
%txt(200*34+1:200*34+200)  --> test, dass ich dabei Indien auswähle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Compute inter-industry Matrix Z in absolute values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 Z=zeros(length(A));
 for j=1:length(A);
    Z(:,j)=BPW(j)*A(:,j);
 end
%  Z_row=sum(Z,2);
%  Z_column=sum(Z);
%  share_Z_vertical=Z_column./BPW';
clear txt
clear num
clear raw

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






