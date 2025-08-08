%{
#include <stdio.h>
#include <string.h>
%}

%option noyywrap

// macros 
DIGIT       [0-9]
NONZERO     [1-9]
ID_START    [A-Za-z_]
ID_CONT     [A-Za-z0-9_]
SIGNS       [+-]?

EXP   ([e][+-]?{DIGIT}+)

FLOAT ({DIGIT}+\.{DIGIT}*({EXP})? | \.{DIGIT}+({EXP})? | {DIGIT}+{EXP})

INT     ({DIGIT}+)

IDENT       ({ID_START}{ID_CONT}*)

ESC_SEQ   (\\[nt0\'\"\\])  
CHAR_LIT  (\'({ESC_SEQ}|[^\'\\\n])\')


// comment
LINE_COMMENT    (\/\/[^\n]*)
BLOCK_COMMENT   (\/\*([^*]|\*+[^*/])*\*+\/)

// preproc
PREPROC     (^([ \t]*)\#[^\n]*)

OP_MULTI    (\+\+|--|==|!=|<=|>=|<<=|>>=|<<|>>|->|::|\+=|-=|\*=|\/=|%=|&=|\|=|\^=|&&|\|\||=>)
OP_SINGLE   ([=+\-*/%<>&|^~!?:])

PUNCT       ([\(\)\{\}\[\],;\.:])

KEYWORD     ("auto"|"break"|"case"|"char"|"const"|"continue"|"do"|"double"|"else"|"enum"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"new"|"return"|"short"|"signed"|"sizeof"|"static"|"static_assert"|"switch"|"throw"|"try"|"typedef"|"void"|"while"|"import")

--------------------------------------------------------------------------------------

%%

// Rules in order

{PREPROC}           { printf("%s\tpreprocessor\n", yytext); }

{KEYWORD}           { printf("%s\tkeyword\n", yytext); }

{IDENT}             { printf("%s\tidentifier\n", yytext); }

{DEC_FLOAT}([fFlL]?) { printf("%s\tfloat\n", yytext); }
{DEC_INT}([uUlL]{1,2})?  { printf("%s\tinteger\n", yytext); }

{RAW_STR}           { printf("%s\traw_string\n", yytext); }
{STR_LIT}           { printf("%s\tstring\n", yytext); }
{CHAR_LIT}          { printf("%s\tchar\n", yytext); }

{LINE_COMMENT}      { /* skip or print if you want */ printf("%s\tcomment_line\n", yytext); }
{BLOCK_COMMENT}     { /* beware: this naive pattern won't handle nested comments */ printf("%s\tcomment_block\n", yytext); }

{OP_MULTI}          { printf("%s\toperator\n", yytext); }
{OP_SINGLE}         { printf("%s\toperator\n", yytext); }

{PUNCT}             { printf("%s\tpunctuation\n", yytext); }

[ \t\r\n]+          { /* skip whitespace silently */ }

/* anything else (fallback) */
.                   { printf("%s\tunknown\n", yytext); }

%%


int main(int argc, char **argv) {
    yylex();
    return 0;
}
