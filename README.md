# Compilador para um Subconjunto de Pascal

Este repositório contém a implementação de parte de um compilador para um subconjunto do Turbo Pascal, sem suporte a arrays e registros (por simplificação).

## Objetivo do projeto

Será implementada os seguintes componentes:

- Analisador léxico (`scanner`)
- Tabela de símbolos
- Analisador sintático (`parser`)
- Se houver tempo:
  - Verificador de tipos
  - Gerador de código intermediário

---

## Atividade 02 (10/05/2026)

**Status:** Realizada em **10/05/2026**  
**Tema:** Implementação do analisador léxico (`scanner`) com Flex.

### Convenções léxicas

- Comentários são delimitados por `{` e `}`.
- Espaços em branco entre tokens são opcionais, exceto que palavras reservadas devem ser delimitadas por espaços, quebras de linha, início do programa ou ponto final.
- Definições:

```text
letter → [a-zA-Z]
digit → [0-9]
id → letter (letter | digit)*

digits → digit digit*
optional_fractional → . digits | ε
optional_exponent → ( E | (+ | - | e ) digits) | ε
num → digits optional_fraction optional_exponent
```

- Palavras-chave são reservadas e aparecem em negrito na gramática.
- Operadores relacionais (`relops`): `=`, `>`, `<`, `>=`, `<=`, `<>`
- Operadores aditivos (`addops`): `+`, `-`, `OR`
- Operadores multiplicativos (`mulops`): `*`, `/`, `DIV`, `MOD`, `AND`
- Token `assignop`: `:=`

### Sintaxe do subconjunto de Pascal

```text
Program → Header Declarations Block .
Header → program id ;
Declarations → VariableDeclarationSection ProcedureDeclarations
VariableDeclarationSection → VAR VariableDeclarations
                          | ε
VariableDeclarations → VariableDeclarations VariableDeclaration
                    | VariableDeclaration
VariableDeclaration → IdentifierList : Type ;
IdentifierList → IdentifierList , id
              | id
Type → integer
    | real
ProcedureDeclarations → ProcedureHeader Declarations Block ;
ProcedureHeader → procedure id ;
Block → begin Statements end
Statements → Statements ; Statement
          | Statement
Statement → id := Expression
         | id ()
         | Block
         | if Expression then Statement ElseClause
         | while Expression do Statement
         | ε
ElseClause → else Statement
          | ε
ExpressionList → ExpressionList , Expression
              | Expression
Expression → SimpleExpression relop SimpleExpression
          | SimpleExpression
SimpleExpression → Term
                | addop Term
                | SimpleExpression addop Term
Term → Term mulop Factor
    | Factor
Factor → id
      | num
      | ( Expression )
      | not Factor
```

---

## Estrutura atual

- `Analisador Léxico/lexer.l`: regras do scanner em Flex.
- `Analisador Léxico/exemplo.pas`: arquivo de teste.

## Como executar

No Linux, dentro da pasta do analisador léxico:

```bash
cd "Analisador Léxico"
flex lexer.l
gcc lex.yy.c -o lexer -lfl
./lexer exemplo.pas
```

Isso gera os tokens reconhecidos pelo scanner para o arquivo `exemplo.pas`.

## Executando a calculadora (Flex, yacc e Bison)

A pasta `Flex, yacc e Bison` contém uma calculadora simples implementada com Flex e Bison.

Passos para compilar e rodar (Linux):

```bash
cd "Flex, yacc e Bison"
bison -d calc.y
flex calc.l
g++ calc.tab.c lex.yy.c -o calculadora
./calculadora
```

Como usar:

- Após executar `./calculadora`, digite expressões e pressione Enter para ver o resultado.
- Linhas em branco são ignoradas; o programa lê até EOF (Ctrl+D para encerrar no terminal).

Operações suportadas:

- **Adição**: `a + b`
- **Subtração**: `a - b`
- **Multiplicação**: `a * b`
- **Divisão**: `a / b` (opera em `double`)
- **Módulo**: use a palavra-chave `gladistony` entre operandos (por exemplo `10 gladistony 3`) — o scanner é case-insensitive para essa palavra.
- **Negação unária**: `-x`
- **Parênteses**: `( ... )` para agrupar subexpressões
- **Números**: inteiros e reais com ponto decimal, por exemplo `42` ou `3.14`.

Exemplos:

```
> 1 + 2
3
> (4 - 2) * 5
10
> 10 gladistony 3
1
> -5 + 7
2
```

Observações técnicas:

- O token de módulo é implementado como um token literal retornado pelo scanner quando encontra a palavra "gladistony" (caso-insensitivo).
- O analisador imprime o valor de cada expressão seguida de nova linha.

## Atividade 03 - Projeto parte 2

Esta etapa do projeto implementa a Análise Semântica do subconjunto de Pascal, utilizando uma Tabela de Símbolos (Symbol Table) para garantir a consistência das regras de negócio da linguagem.

O que foi implementado:
- Tabela de Símbolos (symtable.h / symtable.cpp): Estrutura baseada em hash map para armazenamento eficiente e busca de identificadores.

- Verificação de Declaração: O compilador agora detecta automaticamente dupla declaração de variáveis no mesmo escopo.

- Detecção de Variáveis Não Declaradas: Identificação de uso de identificadores que não foram previamente definidos na seção var.

- Checagem de Tipos (Type Checking):

    - Verificação de compatibilidade em atribuições (:=).

    - Propagação de tipos em expressões aritméticas (ex: Integer + Real = Real).

    - Prevenção de atribuição de valores Real para variáveis do tipo Integer.

Passos para compilar e rodar (Linux):

```bash
cd Analisador\ Semântico/
bison -d parser.y
flex lexer.l
g++ parser.tab.c lex.yy.c symtable.cpp -o compilador
./compilador < testes/test1.pas 
```

Foram feitos 4 arquivos de teste, para usalos basta mudar o nome test1.pas para test2.pas ...

Os resultados esperados são:

test1.pas
```bash
>>> Analise sintatica e semantica concluida com sucesso! <<<
```
test2.pas
```bash
Erro Semantico (Linha 5): Variavel 'x' ja declarada neste escopo!
Erro Semantico (Linha 11): Variavel 'z' nao foi declarada!
Erro Semantico (Linha 13): Atribuicao invalida! Nao e possivel atribuir REAL a variavel INTEGER 'x'.

>>> Analise sintatica e semantica concluida com sucesso! <<<
```
test3.pas
```bash
Erro Semantico (Linha 6): Variavel 'a' ja declarada neste escopo!
Erro Semantico (Linha 19): Atribuicao invalida! Nao e possivel atribuir REAL a variavel INTEGER 'c'.
Erro Semantico (Linha 22): Variavel 'w' nao foi declarada!
Erro Semantico (Linha 25): Variavel 'k' nao foi declarada!

>>> Analise sintatica e semantica concluida com sucesso! <<<
```
test4.pas
```bash
>>> Analise sintatica e semantica concluida com sucesso! <<<
```
