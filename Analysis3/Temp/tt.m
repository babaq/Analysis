figure;
for i =1:30
cep{i} = ep(ep(:,1)>font(i) & ep(:,1)<fofft(i),2:3);
pcep{i} = ep(ep(:,1)>font(i)-50 & ep(:,1)<font(i),2:3);
scep{i} = ep(ep(:,1)>fofft(i) & ep(:,1)<fofft(i)+50,2:3);
subplot(5,6,i);
scatter(pcep{i}(:,1),pcep{i}(:,2),'.g');
hold on;
scatter(cep{i}(:,1),cep{i}(:,2),'.r');
hold on;
scatter(scep{i}(:,1),scep{i}(:,2),'.b');
hold on;
end