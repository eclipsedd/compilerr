%{
#include <stdio.h>
#include <string.h>
%}

%option noyywrap

/* macros */
DIGIT       [0-9]
ID_START    [A-Za-z_]
ID_CONT     [A-Za-z0-9_]

EXP         [eE][+-]?{DIGIT}+

FLOAT       ({DIGIT}+\.{DIGIT}*({EXP})? | \.{DIGIT}+({EXP})? | {DIGIT}+{EXP})

INT         {DIGIT}+

IDENT       {ID_START}{ID_CONT}*

ESC_SEQ     (\\[nt0\'\"\\])
CHAR_LIT    \'({ESC_SEQ}|[^\'\\\n])\'

LINE_COMMENT    \/\/[^\n]*
BLOCK_COMMENT   \/\*([^*]|\*+[^*/])*\*+\/

PREPROC     ^[ \t]*\#[^\n]*

OP_MULTI    (\+\+|--|==|!=|<=|>=|<<=|>>=|<<|>>|->|::|\+=|-=|\*=|\/=|%=|&=|\|=|\^=|&&|\|\||=>)
OP_SINGLE   [=+\-*/%<>&|^~!?:

PUNCT       [\(\)\{\}\[\],;\.:]

KEYWORD     (auto|break|case|char|const|continue|do|double|else|enum|float|for|goto|if|inline|int|long|new|return|short|signed|sizeof|static|static_assert|switch|throw|try|typedef|void|while|import)

%%

{PREPROC}           { printf("%s\tpreprocessor\n", yytext); }

{KEYWORD}           { printf("%s\tkeyword\n", yytext); }

{IDENT}             { printf("%s\tidentifier\n", yytext); }

{FLOAT}([fFlL]?)    { printf("%s\tfloat\n", yytext); }
{INT}               { printf("%s\tinteger\n", yytext); }

{CHAR_LIT}          { printf("%s\tchar\n", yytext); }

{LINE_COMMENT}      { /* skip or print if you want */ printf("%s\tcomment_line\n", yytext); }
{BLOCK_COMMENT}     { /* note: doesn't support nested comments */ printf("%s\tcomment_block\n", yytext); }

{OP_MULTI}          { printf("%s\toperator\n", yytext); }
{OP_SINGLE}         { printf("%s\toperator\n", yytext); }

{PUNCT}             { printf("%s\tpunctuation\n", yytext); }

[ \t\r\n]+          { /* skip whitespace silently */ }

.                   { printf("%s\tunknown\n", yytext); }

%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}
