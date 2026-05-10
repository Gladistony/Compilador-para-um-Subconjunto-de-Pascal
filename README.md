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
