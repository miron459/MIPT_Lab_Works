%open files
data=Data;
data=data.parsefiles();

%plotseries(data);
ix=[1 1 1];
iy=[2 2 2];
plotNums=[3 2 1];
plotseries(data, ix, iy, plotNums);
