%{
	#include <stdio.h>
	#include <iostream>
	#include <string.h>

	int yylex();
	char msg[70];
	int yyerror(const char *msg);

	FILE * yyies = NULL;
	
        int EsteCorecta = 1;

	int Prima = 0;
	
	class TVAR
	{
		char* name;
		int valoare;
		TVAR* next;
		
		public :
				static TVAR* head;
				static TVAR* tail;
				TVAR(char* n,int v=-1);
				TVAR();
				int exists(char* n);
				void add(char* n,int v=-1);
				int getValue(char* n);
				void setValue(char* n,int v);
		
	};
	
	TVAR* TVAR::head=NULL;
	TVAR* TVAR::tail=NULL;
	
	TVAR::TVAR(char* n,int v)
	{
		this->name=new char[strlen(n)+1];
		strcpy(this->name,n);
		this->valoare=v;
		this->next=NULL;
	}
	
	TVAR::TVAR()
	{

	}
	
	int TVAR::exists(char* n)
	{
		TVAR* aux=TVAR::head;
		
		while(aux!=NULL)
		{
			if(strcmp(aux->name,n)==0)
				return 1;
			aux=aux->next;
		}
		return 0;
	}
	
	void TVAR::add(char* n,int v)
	{
		TVAR* elem=new TVAR(n,v);
		if(TVAR::head==NULL)
		{
			TVAR::head=elem;
			TVAR::tail=elem;
		}
		else
		{
			TVAR::tail->next=elem;
			TVAR::tail=elem;
		}
	}
	
	int TVAR::getValue(char* n)
	{
		TVAR* aux=TVAR::head;
		while(aux!=NULL)
		{
			if(strcmp(aux->name,n)==0)
				return aux->valoare;
			aux=aux->next;
		}
		return 0;
	}
	
	void TVAR::setValue(char* n,int v)
	{
		TVAR* aux=TVAR::head;
		while(aux!=NULL)
		{
			if(strcmp(aux->name,n)==0)
			aux->valoare=v;
		aux=aux->next;
		}	
	}	
	
	TVAR* instance=NULL;
	
	
	

%}
%union { char* sir; int val;}
%token <sir> TOKEN_PROGRAM TOKEN_VAR TOKEN_BEGIN TOKEN_END TOKEN_ID TOKEN_SEMICOLON TOKEN_COLON 
%token <sir> TOKEN_INTEGER TOKEN_COMMA TOKEN_PLUS TOKEN_MINUS TOKEN_MUL TOKEN_DIV 
%token <sir> TOKEN_READ TOKEN_WRITE TOKEN_FOR TOKEN_DO TOKEN_TO TOKEN_COLEQ TOKEN_ERROR
%token <val> TOKEN_RBRACKET TOKEN_LBRACKET TOKEN_INT
%type <sir> idlist
%type <val> factor exp term
%start prog
%left TOKEN_PLUS TOKEN_MINUS
%left TOKEN_DIV TOKEN_MUL
%locations


%%
prog :
	 |
	 TOKEN_PROGRAM progname TOKEN_VAR declist TOKEN_BEGIN stmtlist TOKEN_END '.'
	 |
	 error
	 { EsteCorecta=0; }
	 ;
progname :
	 TOKEN_ID;

declist :
		 dec
		 | 
		 declist TOKEN_SEMICOLON dec 
		 ;
		 
dec 	 :
		 idlist TOKEN_COLON type
      		{

			char* auxiliar=(char*)malloc(sizeof(char)*60);
			strcpy(auxiliar,$1);
			char* auxiliar2=(char*)malloc(sizeof(char)*20);
			auxiliar2=strtok(auxiliar,"+");
			while(auxiliar2!=NULL)
			{
				if(instance->exists(auxiliar2)==1)
				{
					sprintf(msg,"Eroare:Variabila %s a mai fost declarata", auxiliar2);
					yyerror(msg);
					
				}
				else
				{
					instance->add(auxiliar2,0);
				}
				auxiliar2=strtok(NULL,"+");
			}
		}
		 ;
		 
type     :
		 TOKEN_INTEGER
		 ;
		 
idlist  :
		 TOKEN_ID
		 |
		 idlist TOKEN_COMMA TOKEN_ID
		 {
			 strcat($$,"+");
			 strcat($$,$3);
			
		 }
		 ;

stmtlist  :
		   stmt
		   |
		   stmtlist TOKEN_SEMICOLON stmt
		   ;
		   
stmt		:
			assign
			|
			read
			|
			write
			|
			for
			;
			
assign      : 
		     TOKEN_ID TOKEN_COLEQ exp
			 {
				if(instance->exists($1))
				{
					instance->setValue($1,1);
				}
				else
				{
					sprintf(msg,"Eroare:Variabila %s nu a fost declarata", $1);
					yyerror(msg);
					
					
				}
			 }
			 ;
			 
exp 		:
			term
			|
			exp TOKEN_PLUS term
			|
			exp TOKEN_MINUS term
			;
			
term		: 
			factor 
			|
			term TOKEN_MUL factor
			|
			term TOKEN_DIV factor
			{
				if($3==0)
				{
					sprintf(msg,"Eroare:Nu se poate calcula impartirea la 0!");
					yyerror(msg);
					
				}
			}
			;
			
factor      : 
			TOKEN_ID
			{
				if(instance->exists($1))
				{
					if(instance->getValue($1)==0)
					{
					sprintf(msg,"Eroare:Variabila %s nu a fost initializata",$1);
					yyerror(msg);
					}
					
				}
				else
				{
					sprintf(msg,"Eroare:Variabila %s nu a fost declarata!",$1);
					yyerror(msg);
					
				}
			}
			|
			TOKEN_INT
			|
			TOKEN_LBRACKET exp TOKEN_RBRACKET
			;
			
read		: 
			TOKEN_READ TOKEN_LBRACKET idlist TOKEN_RBRACKET
			{
				char* auxiliar=(char*)malloc(sizeof(char)*20);
				strcpy(auxiliar,$3);
				char* auxiliar2=(char*)malloc(sizeof(char)*20);
				auxiliar2=strtok(auxiliar,",");
				while(auxiliar2)
				{
					if(instance->exists(auxiliar2))
					{
						instance->setValue(auxiliar2,1);
					}
					else
					{
						sprintf(msg,"Eroare:Variabila %s nu a fost declarata",auxiliar2);
						yyerror(msg);
						
					}
				auxiliar2=strtok(NULL,",");
				}
			}
			;
			
write		:
			TOKEN_WRITE TOKEN_LBRACKET idlist TOKEN_RBRACKET
			{
				char* auxiliar=(char*)malloc(sizeof(char)*20);
				strcpy(auxiliar,$3);
				char* auxiliar2=(char*)malloc(sizeof(char)*20);
				auxiliar2=strtok(auxiliar,",");
				while(auxiliar2)
				{
					if(instance->exists(auxiliar2))
					{
						if(instance->getValue(auxiliar2)==0)
							{
							sprintf(msg,"Eroare:Variabila %s nu a fost initializata",auxiliar2);
							yyerror(msg);
							}
							
					}
					else
					{
						sprintf(msg,"Eroare:Variabila %s nu a fost declarata",auxiliar2);
						yyerror(msg);
						
					}
				auxiliar2=strtok(NULL,",");
				}
			}
			;
			
for			:
			TOKEN_FOR indexexp TOKEN_DO body
			;
			
indexexp	:
			TOKEN_ID TOKEN_COLEQ exp TOKEN_TO exp
			{
				if(instance->exists($1)==0)
				{
					sprintf(msg,"Eroare:Variabila %s nu a fost declarata!",$1);
					yyerror(msg);
					
				}
				else
				{
					instance->setValue($1,1);
				}
			}
			;
			
body		:
			stmt
			|
			TOKEN_BEGIN stmtlist TOKEN_END
			;


%%

int main()
{
	
	yyparse();
	if(EsteCorecta == 1)
	{
		printf("CORECTA\n");		
	}	
       return 0;
}

int yyerror(const char *msg)
{
	EsteCorecta=0;
	printf("Error: %s\n", msg);
	return 1;
}
