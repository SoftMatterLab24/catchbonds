clear all
close all

%load data
D = load("force.out");

time = D(:,1);
attached = D(:,2);
force = D(:,3);

%Timestep
dt = 0.1;

%Catch Parameters
ka0 = 0.0848;
kd0 = 0.0074;
f0 = 0.0004;
eta = 1;

B = 2*eta^2 + 2*sqrt(eta^4 - eta^2) -1;

f = abs(max(force));

%Compute the theoretical value for kd
kd = (kd0/(B+1))*(exp(f/f0) + B*exp(-f/f0));
% time = (1:1000);
% Pd = exp(-kd*time);
%% Compute the true lifetime for bonds
jj = 1;
lifetimes(jj) = 0;
for ii = 2:length(attached)
    if attached(ii) == attached(ii-1) && attached(ii) == 0
        continue
    elseif attached(ii) == 0 && attached(ii-1) == 1
        jj = jj + 1;
        lifetimes(jj) = 0;
    else
        lifetimes(jj) = lifetimes(jj) + dt;
    end
end

figure(1)
plot(time,attached,'LineWidth',1.25)

figure(2); hold on
histogram(lifetimes,50,'Normalization','probability')

tau_theoretical = kd^-1;

tau_mean = mean(lifetimes);
tau_std = std(lifetimes);
tau_SE = tau_std/sqrt(length(lifetimes));

fprintf('Theoretical Average Bond Lifetime: %4.4f sec\nTrue Average Bond Lifetime: %4.4f sec\n',tau_theoretical,tau_mean)
