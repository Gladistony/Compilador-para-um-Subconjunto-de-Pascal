program TesteCompleto;

var
  i, j, k : integer;
  x, y : real;

begin
  { Teste de atribuição simples }
  i := 10;
  j := 20;
  
  { Teste de expressão com inteiros }
  k := i + j * 2;
  
  { Teste de conversão automática (Int -> Real) }
  x := i;
  
  { Teste de expressão com reais }
  y := x + 3.1415;
  
  { Teste de estruturas de controlo }
  if i < j then
    begin
      i := i + 1;
      x := x + 0.5
    end
  else
    x := 0.0;
    
  { Teste de loop }
  while i < 15 do
    begin
      i := i + 1;
      y := y * 1.1
    end
end.