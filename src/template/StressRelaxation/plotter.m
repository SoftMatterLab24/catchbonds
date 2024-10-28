clear all
close all

D = load("Energy.out");

figure(1)
plot(D(:,1),D(:,5)/max(D(:,5)))