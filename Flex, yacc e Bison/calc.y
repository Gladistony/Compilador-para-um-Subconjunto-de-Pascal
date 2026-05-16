%{
#include <iostream>
#include <cstdlib>
#include <cmath>

using namespace std;

int yylex();
int yyparse();
void yyerror(const char *s);
%}

%define api.value.type {double}

/* Tokens */
%token NUMBER
%token GLADISTONY

/* Precedência e associatividade*/
%left '+' '-'
%left '*' '/' GLADISTONY
%nonassoc UMINUS 

%%

/* Gramatica */

calc:
    calc expr '\n'       { cout << $2 << endl; } 
  | calc '\n'            { /* Linhas em branco */ }
  | /* vazio */          { /* Condição de parada / epsilon */ }
  ;

expr:
    expr '+' expr           { $$ = $1 + $3; }
  | expr '-' expr           { $$ = $1 - $3; }
  | expr '*' expr           { $$ = $1 * $3; }
  | expr '/' expr           { $$ = $1 / $3; }
  | expr GLADISTONY expr    { $$ = fmod($1, $3); }
  | '-' expr %prec UMINUS   { $$ = -$2; }       
  | '(' expr ')'            { $$ = $2; }
  | NUMBER                  { $$ = $1; }
  ;

%%

void yyerror(const char *s) {
    cout << "Erro: " << s << endl;
}

int main() {
    yyparse();
    return 0;
}