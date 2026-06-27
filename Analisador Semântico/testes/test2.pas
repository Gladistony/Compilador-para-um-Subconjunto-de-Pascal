program teste;

var
  x, y : integer;
  x : real; { ERRO SEMÂNTICO 1: A variável 'x' já foi declarada acima }

begin
  x := 10;
  y := 5;
  
  z := 20; { ERRO SEMÂNTICO 2: A variável 'z' nunca foi declarada na secção var }
  
  x := 3.14; { ERRO SEMÂNTICO 3: Tentativa de guardar um valor REAL numa variável INTEGER }
end.