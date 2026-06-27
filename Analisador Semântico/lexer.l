%{
#include <iostream>
#include <string.h>
#include <cstdlib>
#include "symtable.h"
#include "parser.tab.h"

using namespace std;
%}

%option noyywrap
%option nodefault yylineno
%option case-insensitive

DIGIT      [0-9]
LETTER     [a-zA-Z]
ID         {LETTER}({LETTER}|{DIGIT})*
DIGITS     {DIGIT}+
NUM        {DIGITS}(\.{DIGITS})?([Ee][+-]?{DIGITS})?

%%

\{[^}]*\}                   { /* Ignora comentários */ }
[ \t\r\n]+                  { /* Ignora espaços e quebras de linha */ }

"program"                   { return T_PROGRAM; }
"var"                       { return T_VAR; }
"integer"                   { return T_INTEGER; }
"real"                      { return T_REAL; }
"procedure"                 { return T_PROCEDURE; }
"begin"                     { return T_BEGIN; }
"end"                       { return T_END; }
"if"                        { return T_IF; }
"then"                      { return T_THEN; }
"else"                      { return T_ELSE; }
"while"                     { return T_WHILE; }
"do"                        { return T_DO; }
"not"                       { return T_NOT; }

":="                        { return T_ASSIGNOP; }
">="|"<="|"<>"|"="|">"|"<"  { return T_RELOP; }
"+"|"-"|"or"                { return T_ADDOP; }
"*"|"/"|"div"|"mod"|"and"   { return T_MULOP; }
";"|"."|":"|","|"("|")"     { return yytext[0]; /* Retorna o próprio caractere como token */ }

{ID}                        { 
                              // O strdup copia a string para a memória. 
                              // O Bison vai receber este nome através do yylval.str
                              yylval.str = strdup(yytext); 
                              return T_ID; 
                            }
{NUM}                       { 
                              yylval.str = strdup(yytext); 
                              return T_NUM; 
                            }

.                           { cout << "Erro Léxico (Linha " << yylineno << "): Caractere invalido '" << yytext << "'" << endl; }

%%