%open files
data=Data;
data=data.parsefiles();

i=data.indexByName('Temperature dependence 2');
s=3900;
e=max(size(data.data{i}))-2400;
shift=12.1;
newdat=[data.data{i}(s:e,1),...
        data.data{i}(s:e,2)+shift,...
        data.data{i}(s:e,3)];
data=data.add(newdat, 'Extrapolated', {'a' 'b' 'c'});
plot_series(data, 2, 1, 2);