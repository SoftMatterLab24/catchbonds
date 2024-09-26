

%% Analytical Solution
disp = [0:0.0001:0.05];
f =  2*3*disp;

kd_const = (ones(1,length(disp))*0.2).^-1;

kd = 0.1;
fs0 = 0.05;
fc0 = [0 0.03 0.3]; 
kc0 = 10;

kd_C1 = (kd*exp(f/fs0) + kd*kc0*exp(-f/fc0(1))).^-1;
kd_C2 = (kd*exp(f/fs0) + kd*kc0*exp(-f/fc0(2))).^-1;
kd_C3 = (kd*exp(f/fs0) + kd*kc0*exp(-f/fc0(3))).^-1;

%% Simulation Data
%Constant
load('Contant_mean')
load('Contant_std')
load('Contant_force')

life_mean_Constant = life_mean;
life_std_Constant = life_std;
force_mean_Constant = force_mean;

%Catch1
load('Catch1_mean')
load('Catch1_std')
load('Catch1_force')

life_mean_C1 = life_mean;
life_std_C1 = life_std;
force_mean_C1 = force_mean;

%Catch2
load('Catch2_mean',"life_mean")
load('Catch2_std',"life_std")
load('Catch2_force',"force_mean")

life_mean_C2 = life_mean;
life_std_C2 = life_std;
force_mean_C2 = force_mean;

%Catch3
load('Catch3_mean',"life_mean")
load('Catch3_std',"life_std")
load('Catch3_force',"force_mean")

life_mean_C3 = life_mean;
life_std_C3 = life_std;
force_mean_C3 = force_mean;

%% Plotting
figure(1)
plot(f/fs0,kd_const,'k-','LineWidth',1.75)
hold on
errorbar(force_mean_Constant/fs0,life_mean_Constant,-life_std_Constant,life_std_Constant,'Color',[175 175 175]/255,'LineWidth',1.75)

figure(2)
plot(f/fs0,kd_C1,'Color',[0 0 0]/255,'LineWidth',1.75)
hold on
plot(force_mean_C1/fs0,life_mean_C1,'-v','Color',[253 163 27]/255,'LineWidth',1.75)
plot(f/fs0,kd_C2,'Color',[0 0 0]/255,'LineWidth',1.75)
plot(force_mean_C2/fs0,life_mean_C2,'-o','Color',[189 54 64]/255,'LineWidth',1.75)
plot(f/fs0,kd_C3,'Color',[0 0 0]/255,'LineWidth',1.75)
plot(force_mean_C3/fs0,life_mean_C3,'-o','Color',[85 27 118]/255,'LineWidth',1.75)

xlabel('Normalized Force (f/f_s^o)')
ylabel('Lifetime (sec)')
axis("square")
legend('', '' ,'')
