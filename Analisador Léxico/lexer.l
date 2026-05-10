%{
#include <stdio.h>
#include <string.h>

typedef enum {
    T_PROGRAM = 1, T_VAR, T_INTEGER, T_REAL, T_PROCEDURE,
    T_BEGIN, T_END, T_IF, T_THEN, T_ELSE, T_WHILE, T_DO, T_NOT,
    T_ASSIGNOP, T_RELOP, T_ADDOP, T_MULOP, T_DELIMITER,
    T_ID, T_NUM
} TokenType;

void print_token(TokenType type, const char* lexeme);
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

\{[^}]*\}                   { /* Ignora comentários delimitados por { e } */ }
[ \t\r\n]+                  { /* Ignora espaços, tabs e quebras de linha */ }

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
";"|"."|":"|","|"("|")"     { return T_DELIMITER; }

{ID}                          { return T_ID; }
{NUM}                         { return T_NUM; }

.                              { printf("Erro Lexico: Caractere invalido '%s' na linha %d\n", yytext, yylineno); }

%%

void print_token(TokenType type, const char* lexeme) {
    const char* type_str = "";
    switch(type) {
        case T_PROGRAM:   type_str = "KEYWORD (program)"; break;
        case T_VAR:       type_str = "KEYWORD (var)"; break;
        case T_INTEGER:   type_str = "KEYWORD (integer)"; break;
        case T_REAL:      type_str = "KEYWORD (real)"; break;
        case T_PROCEDURE: type_str = "KEYWORD (procedure)"; break;
        case T_BEGIN:     type_str = "KEYWORD (begin)"; break;
        case T_END:       type_str = "KEYWORD (end)"; break;
        case T_IF:        type_str = "KEYWORD (if)"; break;
        case T_THEN:      type_str = "KEYWORD (then)"; break;
        case T_ELSE:      type_str = "KEYWORD (else)"; break;
        case T_WHILE:     type_str = "KEYWORD (while)"; break;
        case T_DO:        type_str = "KEYWORD (do)"; break;
        case T_NOT:       type_str = "KEYWORD (not)"; break;
        case T_ASSIGNOP:  type_str = "ASSIGNOP"; break;
        case T_RELOP:     type_str = "RELOP"; break;
        case T_ADDOP:     type_str = "ADDOP"; break;
        case T_MULOP:     type_str = "MULOP"; break;
        case T_DELIMITER: type_str = "DELIMITER"; break;
        case T_ID:        type_str = "ID"; break;
        case T_NUM:       type_str = "NUM"; break;
    }
    printf("%-22s | %-15s | Linha: %d\n", type_str, lexeme, yylineno);
}

int main(int argc, char** argv) {
    if (argc > 1) {
        FILE* file = fopen(argv[1], "r");
        if (!file) {
            perror("Erro ao abrir arquivo");
            return 1;
        }
        yyin = file; /* yyin é o ponteiro de leitura padrão do Flex */
    }

    printf("%-22s | %-15s | %s\n", "TIPO DO TOKEN", "LEXEMA", "POSICAO");
    printf("------------------------------------------------------------\n");

    TokenType t;
    while ((t = yylex())) {
        print_token(t, yytext);
    }

    return 0;
}