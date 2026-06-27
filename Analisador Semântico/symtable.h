#ifndef SYMTABLE_H
#define SYMTABLE_H

#include <iostream>
#include <string>
#include <unordered_map>

using namespace std;

//Tipos que vamos usar
enum Type { 
    TYPE_INT, 
    TYPE_REAL, 
    TYPE_UNKNOWN 
};

//Estrutura 
struct Symbol {
    string name;
    Type type;
};

//Tabela de Símbolos
extern unordered_map<string, Symbol> symtable;

// Funções que o Bison
bool add_symbol(string name, Type type);
Type get_symbol_type(string name);

#endif