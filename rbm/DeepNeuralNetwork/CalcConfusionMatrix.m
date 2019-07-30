function ConfusionMatrix = CalcConfusionMatrix( dbn, IN, OUT )
 out = v2h( dbn, IN );
 [~, pred] = max(out, [], 2);
 [~, act]  = max(OUT, [], 2);

%  out = zeros(size(out));
%  for i=1:size(out,1)
%   out(i,ind(i))=1;
%  end
 
 ConfusionMatrix = zeros(10, 10);
 for i = 1:min(size(pred), size(act))
     ConfusionMatrix(pred(i), act(i)) = ConfusionMatrix(pred(i), act(i)) + 1;
 end

end

