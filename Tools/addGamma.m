function addGamma(filename)
%ADDGAMMA Add Gamma to old colorInfo2 files.

path = fullfile(pwd, 'Saved colorInfo2', filename);
load(path)

% Parameters
maxGunLvl = 255;
stepsPerGun = 8;
nGuns = 3;
stepSize = (maxGunLvl + 1) / stepsPerGun;
intensityRange = stepSize:stepSize:maxGunLvl+1;
normOutput = colorInfo2.normOutput;

% Gamma loop
for eachGun = 1:nGuns
    lums = normOutput(:,eachGun); %one gun at a time
    int = intensityRange / maxGunLvl; %normalize intensity levels
    gf = fittype('x^gf');
    fittedmodel = fit(int',lums,gf);
    gammaVals(eachGun) = fittedmodel.gf; % Get the gamma value
    temp = ((([0:maxGunLvl]'/maxGunLvl))).^(1/fittedmodel.gf); %#ok<NBRAK>
    gammaTable(1:maxGunLvl+1,eachGun) = temp';
end

% Add to colorInfo2
colorInfo2.Gamma = gammaVals;
fprintf('Adding gamma R = %2.2f, G = %2.2f, B = %2.2f\n', gammaVals);
save(strcat(filename, '_g.mat'), 'colorInfo2', 'gammaTable');
fprintf('%s_g saved\n', filename)

end

