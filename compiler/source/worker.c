// ************************************************************************************************
// ************************************************************************************************
//
//       Name :      worker.c
//       Purpose :   Compile worker
//       Date :      24th March 2026
//       Author :    Paul Robson (paul@robsons.org.uk)
//
// ************************************************************************************************
// ************************************************************************************************
 
#include <compiler.h>

static void COMCompileConstant(int n);
static void COMCompileIdentifier(IDENTIFIER *id);
static void COMCompile(bool isWord,int value,char *comment);

/**
 * @brief      Generate the code for the given word.
 *
 * @param      word  Word in upper case, except for quoted strings.
 */
void COMCompileWord(char *word) {
    if (*word == '\0') return ;
    //
    //      Try word in dictionary.
    //
    IDENTIFIER *id = IDFind(word);
    if (id) {
        COMCompileIdentifier(id);
        return;
    }
    //
    //      Try decimal/hexadecimal constant
    //
    int n = 0;
    if (StringToInteger(word,&n)) {
        COMCompileConstant(n);
        return;
    }    
    //
    //      Definition ?
    //
    if (word[0] == ':' && strlen(word) > 1) {
        if ((RTGetPCTR() & 1) != 0) {
            COMCompile(false,0,"(align)");
        }
        IDAdd(word+1,CodeWord,RTGetPCTR());
        if (strcmp(word,":MAIN") == 0) {
            RTWriteLong(RTGetBaseAddress()+RTOFFSET_BOOT,RTGetPCTR());
        }
        return;
    }
    //
    //      Variable
    //
    if (strcmp(word,"VARIABLE") == 0) {
        COMCompileWord("VAR.HANDLER");
        COMCompile(true,0,"0");
        return;
    }
    //
    //      Constant string.
    //
    if (word[0] == '"' && strlen(word) >= 2 && word[strlen(word)-1] == '"') {
        char temp[4];
        COMCompileWord("STRING.HANDLER");
        for (int i = 1;i < strlen(word)-1;i++) {
            if (word[i] == '_') {
                word[i] = ' ';
            }
            temp[0] = temp[2] = '\'';temp[3] = '\0';temp[1] = word[i];
            COMCompile(false,word[i],temp);
        }
        COMCompile(false,0,"EOL");
        return;
    }
    fprintf(stderr,"... [%s]\n",word);
}

/**
 * @brief      Compile an identifier or bytecode
 *
 * @param      id    The bytecode/identifier record.
 */
static void COMCompileIdentifier(IDENTIFIER *id) {
    if (id->type == ByteCode) {
        COMCompile(false,id->value,id->name);
    } else {
        int addr = id->value;
        ASSERT(addr % 2 == 0);
        addr = (addr >> 1) | 0x8000;
        addr = ((addr >> 8) | (addr << 8)) & 0xFFFF;
        COMCompile(true,addr,id->name);
    }
}

/**
 * @brief      Compile an integer constant
 *
 * @param[in]  n     value to compile
 */
static void COMCompileConstant(int n) {
    char temp[16];
    sprintf(temp,"#%d",n);
    n = n & 0xFFFF;
    if (n < 256) {
        COMCompile(false,0,"Short.Constant");
        COMCompile(false,n,temp);
    } else {
        COMCompile(false,1,"Long.Constant");
        COMCompile(true,n,temp);
    }
}

/**
 * @brief      Compile a byte or word.
 *
 * @param[in]  isWord   True if word
 * @param[in]  value    Value to compile
 * @param      comment  Associated comment.
 */
static void COMCompile(bool isWord,int value,char *comment) {
    if (true) {
        char line[128];
        sprintf(line,"$%04x : $%0*x\t%s",RTGetPCTR(),isWord ? 4 : 2,value,comment);
        fprintf(stdout,"%s\n",line);
    }
    RTWriteByte(value & 0xFF);
    if (isWord) RTWriteByte(value >> 8);
}
