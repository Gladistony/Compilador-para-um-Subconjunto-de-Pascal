#include "symtable.h"

unordered_map<string, Symbol> symtable;

//Cadastra um novo simbolo
bool add_symbol(string name, Type type) {
    if (symtable.find(name) != symtable.end()) {
        return false;
    }
    symtable[name] = {name, type};
    return true; 
}

//Verifica o tipo de um simbolo
Type get_symbol_type(string name) {
    if (symtable.find(name) == symtable.end()) {
        return TYPE_UNKNOWN; 
    }
    return symtable[name].type;
}