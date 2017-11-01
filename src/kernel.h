/*
  C BASED FORTH-83 MULTI-TASKING KERNEL DEFINITIONS

  Copyright (C) 1988-1990 by Mikael R.K. Patel

*/


/* INCLUDED SYSTEM FUNCTIONS */

#include <strings.h>


/* TYPING SYSTEM AND MISC. STRING MACROS */

#define VOID void

typedef char*  PTR8;
typedef short* PTR16;
typedef long*  PTR32;

typedef VOID (*SUBR)();

#define NIL 0

typedef long BOOL;

#define TRUE  ((BOOL) -1)
#define FALSE ((BOOL)  0)

typedef unsigned       NUM;
typedef unsigned char  NUM8;
typedef unsigned short NUM16;
typedef unsigned long  NUM32;

typedef int   INT;
typedef char  INT8;
typedef short INT16;
typedef long  INT32;

typedef float  FLOAT32;
typedef double FLOAT64;

typedef char  CHAR;
typedef char* CSTR;
typedef char* PSTR;

#define STREQ(s1, s2) ((*(CSTR) s1 == *(CSTR) s2) && \
		       (*(CSTR) s1 + 1 == *(CSTR) s2 + 1) && \
		       !(strcmp((CSTR) s1, (CSTR) s2)))


/* QUEUE DEFINITION */

typedef struct _queue {
    struct _queue *succ, *pred;
} queue, *QUEUE;


/* TASK DEFINITION */

typedef struct {
    queue queue;
    INT32 status;
    PTR32 sp;
    PTR32 s0;
    PTR32 ip;
    PTR32 rp;
    PTR32 r0;
    PTR32 fp;
    PTR32 ep;
} task_header;

typedef struct {
    queue queue;
    INT32 status;
    PTR32 sp;
    PTR32 s0;
    PTR32 ip;
    PTR32 rp;
    PTR32 r0;
    PTR32 fp;
    PTR32 ep;
    INT32 users[1];
} task, *TASK;


/* TASK STATUS FIELD VALUES: ENUMERATE */

#define TERMINATED 0
#define READY      1
#define RUNNING    2
#define IOWAITING  3
#define WAITING    4
#define DELAYED    5


/* VOCABULARY ENTRY DEFINITION, TYPES, AND MODES */

typedef struct _entry {
    struct _entry *link;
    CSTR  name;
    INT32 mode;
    INT32 code;
    INT32 parameter;
} entry, *ENTRY;


/* ENTRY MODE VALUES: SET */

#define NORMAL      0
#define IMMEDIATE   1
#define EXECUTION   2
#define COMPILATION 4
#define HIDDEN      6
#define PRIVATE     8


/* ENTRY CODE VALUES: ENUMERATES */

#define CODE       0
#define COLON      1
#define VARIABLE   2
#define CONSTANT   3
#define VOCABULARY 4
#define CREATE     5
#define USER       6
#define LOCAL      7
#define FORWARD    8
#define FIELD      9
#define EXCEPTION  10


/* ENTRY VISIBILITY MACRO */

#define visible(e, v) \
    (!(((e -> mode & COMPILATION) && (!state.parameter)) || \
       ((e -> mode & EXECUTION) && (state.parameter))  || \
       ((e -> mode & PRIVATE) && (v != current))))


/* NORMAL ENTRY GENERATORS */

#define NORMAL_CONSTANT(v, l, n, p) \
    entry v = \
       {(ENTRY) &l, n, NORMAL, CONSTANT, p};

#define NORMAL_VARIABLE(v, l, n, p) \
    entry v = \
       {(ENTRY) &l, n, NORMAL, VARIABLE, p};


/* VOCABULARY ENTRY DEFINITION */

typedef struct {
    ENTRY link;
    CSTR  name;
    INT32 mode;
    INT32 code;
    ENTRY last;
    ENTRY recognizer;
} vocabulary_entry, *VOCABULARY_ENTRY;

#define NORMAL_VOCABULARY(v, l, n, p, r) \
    vocabulary_entry v = \
       {(ENTRY) &l, n, NORMAL, VOCABULARY, (ENTRY) p, (ENTRY) r};


/* CODE ENTRY DEFINITION */

typedef struct {
    ENTRY link;
    CSTR name;
    INT32 mode;
    INT32 code;
    SUBR subr;
} code_entry, *CODE_ENTRY;


#define NORMAL_CODE(v, l, n, s) \
    code_entry v = \
       {(ENTRY) &l, n, NORMAL, CODE, s};

#define IMMEDIATE_CODE(v, l, n, s) \
    code_entry v = \
       {(ENTRY) &l, n, IMMEDIATE, CODE, s};

#define COMPILATION_CODE(v, l, n, s) \
    code_entry v = \
       {(ENTRY) &l, n, COMPILATION, CODE, s};

#define EXECUTION_CODE(v, l, n, s) \
    code_entry v = \
       {(ENTRY) &l, n, EXECUTION, CODE, s};

#define COMPILATION_IMMEDIATE_CODE(v, l, n, s) \
    code_entry v = \
       {(ENTRY) &l, n, COMPILATION + IMMEDIATE, CODE, s};


/* UNIVERSAL VALUE */

typedef union {
    BOOL             BOOL;
    NUM32            NUM32;
    INT32            INT32;
    FLOAT32          FLOAT32;
    CSTR             CSTR;
    PTR8             PTR8;
    PTR16            PTR16;
    PTR32            PTR32;
    SUBR             SUBR;
    QUEUE            QUEUE;
    TASK             TASK;
    ENTRY            ENTRY;
    CODE_ENTRY       CODE_ENTRY;
    VOCABULARY_ENTRY VOCABULARY_ENTRY;
} UNIV, *PTR;


/* STACK MACROS */

#define sinit() sp = s0
#define spop(t) tos.t; tos = *sp++
#define spush(e, t) *(--sp) = tos; tos.t = e
#define snth(n) sp[n]
#define sdrop() tos = *sp++
#define sndrop(n) sp += (n); tos = *sp++
#define snip() sp++
#define sdup() *(--sp) = tos
#define sover() { register UNIV t; t = *sp; *(--sp) = tos; tos = t; }
#define stuck() { register UNIV t; t = *sp; *sp = tos; *(--sp) = t; }
#define sswap() { register UNIV t; t = tos; tos = sp[0]; sp[0] = t; }
#define srot()  { register UNIV t; t = tos; tos = sp[1]; sp[1] = sp[0]; sp[0] = t; }
#define sdashrot() { register UNIV t; t = tos; tos = sp[0]; sp[0] = sp[1]; sp[1] = t; }

#define coerce(f, t) tos.t = (t) tos.f
#define unary(o, t) tos.t = o tos.t
#define binary(o, t) tos.t = sp++ -> t o tos.t
#define compare(o, t) tos.BOOL = (tos.t o ? TRUE : FALSE)
#define relation(o, t) tos.INT32 = (sp++ -> t o tos.t ? TRUE : FALSE)

#define rinit() rp = r0
#define rpop() *rp++
#define rpush(e) *(--rp) = (INT32) e
#define rnth(n) rp[n]
#define rndrop(n) rp += n    


/* THREADING ALIGNMENT MACRO */

#define align(p) p = (PTR32) ((INT32) ((PTR8) p + 3) & -4)


/* THREADED BRANCH, RETURN MACRO */

#define fskip() ip++
#define fbranch(d) ip = (PTR32) ((PTR8) ip + (d))
#define fjump(a) ip = (PTR32) (a)
#define fsemicolon() fjump(rpop())
#define fdoes() current -> last -> code = (INT32) ip; fsemicolon()


/* ARGUMENT AND LOCAL VARIABLE FRAME MACRO */

#define flink() \
{ \
    spush(fp, PTR32); \
    fp = (PTR32) sp + *ip++; \
    sp = sp - *ip++; \
    rpush(sp); \
} 

#define funlink() \
{ \
    register PTR32 t; \
    register PTR32 s; \
    t = (PTR32) rpop(); \
    if (t == (PTR32) sp) { \
	sp = (PTR) fp; \
	fp = tos.PTR32; \
	sdrop(); \
    } \
    else { \
	s = fp; \
	fp = (PTR32) *--t; \
	while (t > (PTR32) sp) *--s = *--t; \
	sp = (PTR) s; \
    } \
}    

#define fcatch() \
{ \
    PTR32 body; \
    body = spop(PTR32); \
    rpush(tos.INT32); \
    rpush(sp); \
    rpush(ip); \
    rpush(fp); \
    rpush(ep); \
    ep = rp; \
    fjump(body); \
}

#define fthrow() \
{ \
    ep = (PTR32) rpop(); \
    rndrop(4); \
    fsemicolon() ; \
}
    
/* EXTERN FORWARD DECLARATIONS */

extern INT32 verbose;
extern INT32 quited;
extern INT32 running;
extern INT32 tasking;

extern TASK tp;
extern TASK foreground;

extern UNIV tos;
extern PTR  sp;
extern PTR  s0;

extern PTR32 ip;
extern PTR32 rp;
extern PTR32 r0;

extern PTR32 fp;
extern PTR32 ep;

extern PTR32 dictionary;
extern PTR32 dp;

extern vocabulary_entry forth;

TASK  make_task();
ENTRY make_entry();

VOID kernel_initiate();
VOID kernel_finish();

VOID doinner();
VOID docommand();
VOID docall();
VOID doappend();

  
/* COMPILER EXTENSIONS */

VOID doparenbranch();
VOID doparenqbranch();
VOID doparendo();
VOID doparenqdo();
VOID doparenloop();
VOID doparenplusloop();
VOID doparenliteral();
VOID doparendotquote();
VOID doparenabortquote();
VOID doparensemicolon();
VOID doparendoes();
VOID dothread();
VOID dounthread();
VOID doforwardmark();
VOID dobackwardmark();
VOID doforwardresolve();
VOID dobackwardresolve();


/* LOCAL VARIABLES AND ARGUMENT BINDING */

VOID dounlinklocals();
VOID doparenlink()  ;
VOID doparenunlink()  ;
VOID doparenunlinksemicolon() ;
VOID doparenunlinkdoes();
VOID doparenlocal();
VOID doparenlocalstore();
VOID doparenlocalfetch();
VOID doassignlocal();
VOID dolocalreturn();
VOID docurlebracket();


/* NULL TERMINATED STRING */

VOID doparenquote();
VOID doquote();
VOID doslength();
VOID dosdup();
VOID dosequal();
VOID doscompare();
VOID doscat();
VOID dosprint();


/* FLOATING POINT NUMBERS */

VOID doitof();
VOID doftoi();
VOID dofplus();
VOID dofminus();
VOID doftimes();
VOID dofdivide();
VOID dofonedivide();
VOID dofnegate();
VOID dofdot();
VOID doqfloat();


/* MEMORY MANAGEMENT */

VOID domalloc();
VOID dorealloc();
VOID dofree();


/* DOUBLE LINKED LISTS */

VOID doqemptyqueue();
VOID doenqueue();
VOID dodequeue();


/* MULTI-TASKING EXTENSIONS */

VOID douser();
VOID dotask();
VOID dofork();
VOID doresume();
VOID doschedule();
VOID dodetach();
VOID doterminate();


/* SIGNAL AND EXCEPTION MANAGEMENT */

VOID donewexception();
VOID doparenexceptionsemicolon();
VOID doparenexceptionunlinksemicolon();
VOID doparenexception();
VOID doexception();
VOID doraise();


/* KERNEL VOCABULARY */

VOID doboolean();
VOID donot();
VOID doand();
VOID door();
VOID doxor();
VOID doqwithin();

VOID dodepth();
VOID dodrop();
VOID donip();
VOID doswap();
VOID dorot();
VOID dodashrot();
VOID doroll();
VOID doqdup();
VOID dodup();
VOID doover();
VOID dotuck();

VOID dotor();
VOID dofromr();
VOID docopyr();

VOID dotwotor();
VOID dotwofromr();
VOID dotwodrop();
VOID dotwoswap();
VOID dotworot();
VOID dotwodup();
VOID dotwoover();

VOID dolessthan();
VOID doequals();
VOID dogreaterthan();
VOID dozeroless();
VOID dozeroequals();
VOID dozerogreater();
VOID doulessthan();

VOID doplus();
VOID dominus();
VOID dooneplus();
VOID dooneminus();
VOID dotwoplus();
VOID dotwominus();
VOID dotwotimes();
VOID doleftshift();
VOID dotimes();
VOID doumtimes();
VOID doumdividemod();
VOID dotwodivide();
VOID dorightshift();
VOID dodivide();
VOID domod();
VOID dodividemod();
VOID dotimesdividemod();
VOID dotimesdivide();
VOID domin();
VOID domax();
VOID doabs();
VOID donegate();

VOID dofetch();
VOID dostore();
VOID dowfetch();
VOID dolesswfetch();
VOID dowstore();
VOID docfetch();
VOID doclessfetch();
VOID docstore();
VOID doffetch();
VOID dolessffetch();
VOID dofstore();
VOID dobfetch();
VOID dobstore();
VOID dotwostore();
VOID dotwofetch();
VOID doplusstore();

VOID docmove();
VOID docmoveup();
VOID dofill();
VOID docount();
VOID dobounds();
VOID dodashtrailing();
VOID dodashmatch();

VOID dobinary();
VOID dooctal();
VOID dodecimal();
VOID dohex();
VOID doconvert();
VOID dolesssharp();
VOID dosharp();
VOID dosharps();
VOID dohold();
VOID dosign();
VOID dosharpgreater();
VOID doqnumber();

VOID dodo();
VOID doqdo();
VOID doloop();
VOID doplusloop();
VOID doleave();
VOID doi();
VOID doj();
VOID doif();
VOID doelse();
VOID dothen();
VOID docase();
VOID doof();
VOID doendof();
VOID doendcase();
VOID dobegin();
VOID dountil();
VOID dowhile();
VOID dorepeat();
VOID doagain();
VOID dorecurse();
VOID dotailrecurse();
VOID doexit();
VOID doexecute();
VOID dobye();

VOID dodot();
VOID dodotr();
VOID doudot();
VOID doudotr();
VOID doascii();
VOID dodotquote();
VOID dodotparen();
VOID dodots();
VOID docr();
VOID doemit();
VOID dotype();
VOID dospace();
VOID dospaces();

VOID dokey();
VOID doexpect();
VOID doline();
VOID dosource();

VOID doforth83();
VOID dointerpret();
VOID doquit();
VOID doabort();
VOID doabortquote();

VOID dohere();
VOID dotobody();
VOID dodotname();
VOID docells();
VOID docellplus();
VOID dosharpif();
VOID dosharpelse();
VOID dosharpthen();
VOID dosharpifdef();
VOID dosharpifundef();
VOID dosharpinclude();
VOID dosharppath();
VOID doparen();
VOID dobackslash();

VOID docomma();
VOID doallot();
VOID doalign();
VOID dodoes();
VOID doimmediate();
VOID doexecution();
VOID docompilation();
VOID doprivate();
VOID dorecognizer();
VOID dobracketcompile();
VOID docompile();
VOID doqcompile();
VOID docompiling();
VOID doliteral();
VOID doleftbracket();
VOID dorightbracket();
VOID doword();

VOID dolast();
VOID dodefinitions();
VOID doonly();
VOID doseal();
VOID dorestore();
VOID dotick();
VOID dobrackettick();
VOID dolookup() ;
VOID dofind();
VOID dorecognize();
VOID doforget();
VOID dowords();
VOID doentry();
VOID doforward();
VOID docode();
VOID docolon();
VOID dosemicolon();
VOID docreate();
VOID dovariable();
VOID doconstant();
VOID dovocabulary();
VOID dofield();

#ifdef PROFILE
VOID docollision();
#endif
