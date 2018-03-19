%open files
data=DataContainer;
data=data.parsefiles();

%plotseries(data);
ix=[1 1 1];
iy=[2 2 2];
plotNums=[3 2 1];
%plotseries(data, ix, iy, plotNums);
a=plotseries(data, 'angle', "len", 'data');
