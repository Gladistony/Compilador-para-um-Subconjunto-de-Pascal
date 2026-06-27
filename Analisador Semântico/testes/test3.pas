program TesteAvancado;

var
  a, b, c : integer;
  media, soma : real;
  a : real; { ERRO 1: A variável 'a' já foi declarada na primeira linha }

begin
  { Atribuições corretas }
  a := 10;
  b := 20;
  
  { Operação válida: Inteiro + Inteiro = Inteiro. 
    Guardar Inteiro numa variável Real ('soma') é permitido em Pascal. }
  soma := a + b; 

  { ERRO 2: a (Int) + 3.14 (Real) resulta num tipo REAL. 
    Tentar guardar um REAL na variável 'c' (que é INTEGER) não é permitido! }
  c := a + 3.14; 

  { ERRO 3: 'w' nunca foi declarada na secção var (erro no lado esquerdo da atribuição) }
  w := a * b; 

  { ERRO 4: 'k' nunca foi declarada (erro no lado direito, como fator de uma conta) }
  media := soma + k; 
end.