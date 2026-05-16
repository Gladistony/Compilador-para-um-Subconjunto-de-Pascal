%{
#include <iostream>
#include <cstdlib>
#include "calc.tab.h" 
using namespace std;
%}

%option noyywrap 
%option case-insensitive

%%

[ \t]+                  { /* Ignora espaços em branco e tabulações */ }
"gladistony"            { return GLADISTONY; }
[0-9]+(\.[0-9]+)?       { 
                          yylval = atof(yytext); 
                          return NUMBER;         
                        }
.|\n                    { 
                          return yytext[0];     
                        }

%%