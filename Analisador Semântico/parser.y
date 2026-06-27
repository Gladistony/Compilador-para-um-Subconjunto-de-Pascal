%{
#include <iostream>
#include <string>
#include <cstring>
#include <vector>
#include "symtable.h"

using namespace std;

extern int yylex();
extern int yylineno;
void yyerror(const char *s);

// Lista temporaria para criar as variaveis com os tipos corretos, levando em conta que os tipos vão no final.
vector<string> id_list; 
%}

%union {
    char* str;  
    int type;   
}

%token <str> T_ID T_NUM
%token T_PROGRAM T_VAR T_INTEGER T_REAL T_PROCEDURE T_BEGIN T_END
%token T_IF T_THEN T_ELSE T_WHILE T_DO T_NOT T_ASSIGNOP
%token T_RELOP T_ADDOP T_MULOP

%type <type> Type Expression SimpleExpression Term Factor

%%

Program:
    Header Declarations Block '.' { cout << "\n>>> Analise sintatica e semantica concluida com sucesso! <<<" << endl; }
    ;

Header:
    T_PROGRAM T_ID ';'
    ;

Declarations:
    VariableDeclarationSection ProcedureDeclarations
    ;

VariableDeclarationSection:
    T_VAR VariableDeclarations
    | /* epsilon */
    ;

VariableDeclarations:
    VariableDeclarations VariableDeclaration
    | VariableDeclaration
    ;

VariableDeclaration:
    IdentifierList ':' Type ';' {
        for (string id : id_list) {
            if (!add_symbol(id, (Type)$3)) {
                cout << "Erro Semantico (Linha " << yylineno << "): Variavel '" << id << "' ja declarada neste escopo!" << endl;
            }
        }
        id_list.clear();
    }
    ;

Type:
    T_INTEGER { $$ = TYPE_INT; }
    | T_REAL  { $$ = TYPE_REAL; }
    ;

IdentifierList:
    IdentifierList ',' T_ID {
        id_list.push_back($3); 
    }
    | T_ID {
        id_list.push_back($1); 
    }
    ;

ProcedureDeclarations:
    ProcedureDeclarations ProcedureHeader Declarations Block ';'
    | /* epsilon */
    ;

ProcedureHeader:
    T_PROCEDURE T_ID ';'
    ;

Block:
    T_BEGIN Statements T_END
    ;

Statements:
    Statements ';' Statement
    | Statement
    ;

Statement:
    T_ID T_ASSIGNOP Expression {
        Type id_type = get_symbol_type($1);
        if (id_type == TYPE_UNKNOWN) {
            cout << "Erro Semantico (Linha " << yylineno << "): Variavel '" << $1 << "' nao foi declarada!" << endl;
        } else {
            if (id_type == TYPE_INT && $3 == TYPE_REAL) {
                cout << "Erro Semantico (Linha " << yylineno << "): Atribuicao invalida! Nao e possivel atribuir REAL a variavel INTEGER '" << $1 << "'." << endl;
            }
        }
    }
    | T_ID '(' ')' 
    | Block
    | T_IF Expression T_THEN Statement ElseClause
    | T_WHILE Expression T_DO Statement
    | /* epsilon */
    ;

ElseClause:
    T_ELSE Statement
    | /* epsilon */
    ;

Expression:
    SimpleExpression T_RELOP SimpleExpression { $$ = TYPE_INT; }
    | SimpleExpression { $$ = $1; }
    ;

SimpleExpression:
    Term { $$ = $1; }
    | T_ADDOP Term { $$ = $2; }
    | SimpleExpression T_ADDOP Term {
        if ($1 == TYPE_REAL || $3 == TYPE_REAL) {
            $$ = TYPE_REAL;
        } else {
            $$ = TYPE_INT;
        }
    }
    ;

Term:
    Term T_MULOP Factor {
        if ($1 == TYPE_REAL || $3 == TYPE_REAL) {
            $$ = TYPE_REAL;
        } else {
            $$ = TYPE_INT;
        }
    }
    | Factor { $$ = $1; }
    ;

Factor:
    T_ID {
        Type t = get_symbol_type($1);
        if (t == TYPE_UNKNOWN) {
            cout << "Erro Semantico (Linha " << yylineno << "): Variavel '" << $1 << "' nao foi declarada!" << endl;
        }
        $$ = t; 
    }
    | T_NUM {
        string num_str($1);
        if (num_str.find('.') != string::npos || num_str.find('e') != string::npos || num_str.find('E') != string::npos) {
            $$ = TYPE_REAL;
        } else {
            $$ = TYPE_INT;
        }
    }
    | '(' Expression ')' { $$ = $2; }
    | T_NOT Factor { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    cout << "Erro Sintatico (Linha " << yylineno << "): " << s << endl;
}

int main() {
    yyparse();
    return 0;
}