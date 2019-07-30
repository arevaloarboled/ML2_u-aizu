%ds=1:mnist;2:fashion;3:cifar
function cunfu(predictions,labels)
  ds=2;
  name=[];
  if ds==1
      name=["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"];
  elseif ds==2
      name=["T-shirt/top" "Trouser" "Pullover" "Dress" "Coat" "Sandal" "Shirt" "Sneaker" "Bag" "Ankle"];
  else
      name=['airplane' 'automobile' 'bird' 'cat' 'deer' 'dog' 'frog' 'horse' 'ship' 'truck'];
  end
  p = csvread(predictions,1);
  l = csvread(labels,1);  
  d=size(p);
  P=zeros(d(1),10)+0.999;  
  L=zeros(d(1),10)+0.999;
  for i=1:d(1)
      P(i,p(i))=1;
      L(i,l(i))=1;
  end
  P=single(P);
  L=single(L);
  plotconfusion(P',L');
end

