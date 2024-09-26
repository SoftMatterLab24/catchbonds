
cd Catch3\
% Files in the directory
listing = dir(pwd);

% Find folders and store the location
jj = 0;
for ii = 1:length(listing)
    name = listing(ii).name;
    isdir = listing(ii).isdir;

    folder = strcat(listing(ii).folder,'\',listing(ii).name);
    
    if  contains(name,'I') && isdir == true
        jj = jj + 1;
        names_sim{jj} = name;
    else
        continue
    end
    
end

for kk = 1:length(names_sim)
    
    cd(strcat('I',num2str(kk)))
    D = readmatrix('force.out','FileType','text');
    counter = 1;
    for ii = 2:length(D(:,2))

        if D(ii,2) == 1 && D(ii-1,2) == 0
            %start of track
            ind = [ii];
            force = [D(ii,3)];
        elseif D(ii,2) == 1 && D(ii-1,2) == 1
            %middle of track
            ind = [ind ii];
            force = [force D(ii,3)];
        elseif D(ii,2) == 0 && D(ii-1,2) == 1
            %end of track
            avgforce(counter) = mean(force);
            lifetime(counter) = length(ind)*0.01;
            counter = counter +1;
        end
    end
        force_mean(kk) = abs(mean(avgforce));
        life_mean(kk) = mean(lifetime);
        life_std(kk) = std(lifetime);
        clear lifetime
        clear avgforce
    cd ../

end

save('Catch3_mean',"life_mean")
save('Catch3_std',"life_std")
save('Catch3_force',"force_mean")
% 
errorbar(force_mean,life_mean,-life_std,life_std)
axis([0 0.3 -5 20])
