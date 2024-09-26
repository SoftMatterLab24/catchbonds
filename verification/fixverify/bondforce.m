clear all
close all

D = readmatrix('force.out','FileType','text');

afile = 'atoms.dump';
bfile = 'bonds.dump';

%[force,disp,time] = calculate_force_disp_fun(afile,bfile);

counter = 1;
%lifetime = NaN(length(D(:,1)),1);
for ii = 2:length(D(:,2))

    if D(ii,2) == 1 && D(ii-1,2) == 0
        %start of track
        ind = [ii];
    elseif D(ii,2) == 1 && D(ii-1,2) == 1
        %middle of track
        ind = [ind ii];
    elseif D(ii,2) == 0 && D(ii-1,2) == 1
        %end of track
        lifetime(counter) = length(ind)*0.1;
        counter = counter +1;
    end

end

mean(lifetime)

figure(1)
plot(D(:,1),D(:,2))

figure(2)
plot(D(:,1),D(:,3))