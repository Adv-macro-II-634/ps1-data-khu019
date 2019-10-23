clear
clc
%import data

raw = readtable('2013_SCF.xlsx');

%transfer data to matrix

raw_mat = table2array(raw);
SCF_2013 = raw_mat(:,3:5);
num=size(raw_mat);

income_all = raw_mat(:,3);
  wage_all = raw_mat(:,4);
  asset_all = raw_mat(:,5);
income =zeros(num(1,1)/5,1);
wage = zeros(num(1,1)/5,1);
asset = zeros(num(1,1)/5,1);
x=0;
y=0;
z=0;
for ii=1:num(1,1)
    x=x+income_all(ii,1);
    y=y+wage_all(ii,1);
    z=z+asset_all(ii,1);
    if rem(ii,5)==0
    
    income(ii/5,1)=x/5;
    wage(ii/5,1) =y/5;
    asset(ii/5,1)=z/5;
   
    x=0;
    y=0;
    z=0;
    end
end
%{
figure(1)
histogram(income,0:1000000)
figure(2)
histogram(wage,0:1000000)
figure(3)
%}
%histogram(asset,50,'Normalization','probability')

%calculate  quantile
%format bank
income_quantile=quantile(income,[0,0.01,0.05,0.10,0.20,0.40,0.60,0.80,0.90,0.95,0.99,1.00])';
asset_quantile=quantile(asset,[0,0.01,0.05,0.10,0.20,0.40,0.60,0.80,0.90,0.95,0.99,1.00])';
wage_quantile=quantile(wage,[0,0.01,0.05,0.10,0.20,0.40,0.60,0.80,0.90,0.95,0.99,1.00])';
Quantiles=[0,0.01,0.05,0.10,0.20,0.40,0.60,0.80,0.90,0.95,0.99,1.00]';
variable={'income','asset','wage'}
T=table(Quantiles,income_quantile,asset_quantile,wage_quantile)

% other statistics
skew_income=skewness(income);
skew_asset =skewness(asset);
skew_wage = skewness(wage);
CV_income = std(income)/mean(income);
CV_asset = std(asset)/mean(income);
CV_wage  = std(wage)/mean(wage);
% get variance of log
% get data, remove all non-positive values
log_income=log(income(income>0));
log_asset = log(asset(asset>0));
log_wage= log(wage(wage>0));

vlg_income=var(log_income)
vlg_asset = var(log_asset)
vlg_wage = var(log_wage)


% gini index and curve

vet_income=ones(length(income(income>0)),1);
vet_asset = ones(length(asset(asset>0)),1);
vet_wage = ones(length(wage(wage>0)),1);
figure(1)
gini_income = gini(vet_income,income(income>0),1);
figure(2)
gini_asset = gini(vet_asset,asset(asset>0),1);
figure(3)
gini_wage = gini(vet_wage,wage(wage>0),1);


