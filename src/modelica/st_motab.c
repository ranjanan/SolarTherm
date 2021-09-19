#include "parse.h"

#include "st_motab.h"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

//#define MOTAB_DEBUG
#ifdef MOTAB_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif

#define ERR(FMT,...) fprintf(stderr,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)

#define NEW(TYPE) (TYPE *)malloc(sizeof(TYPE))
#define NEW_ARRAY(TYPE,N) (TYPE *)malloc(N*sizeof(TYPE))

#define MAXCHARS 4192

static char *newcopy(const char *s){
	size_t l = (1+strlen(s))*sizeof(char);
	char *c = malloc(l);
	memcpy(c,s,l+1);
	return c;
}

static cbool parseMotabHeader(Parser *P,char *name,unsigned maxl,unsigned *nrows,unsigned *ncols);

static cbool parseMetaDataHeaders(Parser *P,MotabData *tab);

static unsigned motab_get_nmeta(MotabData *tab);

/**
	Selectively read just the time and DNI from a weather data file.
	
	FIXME transition to using Modelica's external functions for loading data and interpolating.
*/
MotabData *motab_load(const char *filepath){
	char line[MAXCHARS];
	unsigned i = 0;

	FILE* fp;
	fp = fopen(filepath,"r");  
	MSG("Reading motab file '%s'",filepath);   
	if (fp == NULL){
		ERR("Unable open motab file '%s'. Please check the file name",filepath);
		return NULL;
	}

	/* read the metadata line */
	MotabData *tab = NEW(MotabData);if(!tab)return NULL;
	tab->meta = NULL;
	tab->vals = NULL;

	Parser *P = parseCreateFile(fp);
	
	MSG("Reading header...");
	char tablename[MAXCHARS];
	if(parseMotabHeader(P,tablename,MAXCHARS,&(tab->nrows),&(tab->ncols))){
		tab->name = newcopy(tablename);
		parseMetaDataHeaders(P,tab);
		MSG("Got %u metadata rows",motab_get_nmeta(tab));
		MSG("Reading %u rows and %u cols...",tab->nrows,tab->ncols);
	}else{
		motab_free(tab);
		parseDispose(P);
		return NULL;
	}
	
	tab->vals = NEW_ARRAY(double,tab->nrows*tab->ncols);
	assert(tab->vals);
	
	double val;
	for(int r=0; r<tab->nrows; ++r){
		for(int c=0; c<tab->ncols; ++c){
			if(
				((c == 0) || parseThisString(P,","))
				&& maybe(parseWS(P))
				&& parseDouble(P,&val) 
				&& maybe(parseWS(P))
				&& (c < tab->ncols - 1 || parseEOL(P))
				&& assign(MOTAB_VAL(tab,r,c)=val)
			){
				//MSG("(%d,%d) = %lf",r,c,MOTAB_VAL(tab,r,c));
			}else{
				ERR("Unexpected characters at row %d, col %d",r,c);
				char ctx[MAXCHARS];
				parseStrExcept(P,"\n\r",ctx,MAXCHARS);
				ERR("Current context: %s",ctx);
				parseDispose(P);
				motab_free(tab);
				return NULL;
			}
		}
		//MSG("Finished row %d",r);
	}
	
	// at this point, we KNOW we have successfully read all of the require rows and columns of data
	// although it's possible there is still more data in the file that we haven't read.
	
	// TODO we haven't done anything smart yet with the MotabMetaData.
	
	MSG("Finished reading file.");
	parseDispose(P);
	fclose(fp);
	return tab;
}


cbool parseMotabHeader(Parser *P,char *name,unsigned maxl,unsigned *nrows,unsigned *ncols){
	return
		((
			parseThisString(P,"#1")
			&& parseEOL(P)
			) || parseError(P,"Unrecognised first line in table file.")
		) && ((
			parseThisString(P,"double ")
			&& parseStrExcept(P," (\n\t",name,maxl)
			&& maybe(parseWS(P)) && parseThisString(P,"(")
			&& maybe(parseWS(P)) && parseNumber(P,nrows)
			&& maybe(parseWS(P)) && parseThisString(P,",")
			&& maybe(parseWS(P)) && parseNumber(P,ncols)
			&& maybe(parseWS(P)) && parseThisString(P,")")
			&& parseEOL(P)
			) || parseError(P,"Unable to parse second line in table file.")
		);
}

/**
	Store a metadata row in the linked list tab->meta.
	Note that we take a copy of the string `row` which must later be freed.
*/
static void motab_add_meta(MotabData *tab,char *row){
	MotabMetaData *M = NEW(MotabMetaData);
	assert(row != NULL);
	M->row = newcopy(row);
	assert(M->row != NULL);
	if(tab->meta){
		// insert this row at the start of the linked list
		M->next = tab->meta;
		tab->meta = M;
	}else{
		// this is the first row
		tab->meta = M;
		M->next= NULL;
	}
}

/**
	Parse a metadata row -- nothing smart, just read to the EOL and store the text.
*/
static cbool parseMetaRow(Parser *P,MotabData *tab){
	char row[MAXCHARS];
	return (
		parseThisString(P,"#")
		&& parseStrExcept(P,"\n\r",row,MAXCHARS)
		&& parseEOL(P)
#ifdef MOTAB_DEBUG
		&& assign(MSG("Metadata row '%s'",row))
#endif
		&& assign(motab_add_meta(tab,row))
	);
}

/**
	Store as many lines starting with # as we need, no limit applied.
*/
cbool parseMetaDataHeaders(Parser *P,MotabData *tab){
	return many(parseMetaRow(P,tab));
}


void motab_free(MotabData *tab){
	if(tab){
		if(tab->vals){
			free(tab->vals);
		}
		if(tab->meta){
			MotabMetaData *M = tab->meta;
			MotabMetaData *N;
			while(M){
				if(M->row)free(M->row);
				N = M->next;
				free(M);
				M = N;
			}
		}
		free(tab);
	}
}

unsigned motab_get_nmeta(MotabData *tab){
	unsigned nmeta = 0;
	MotabMetaData *M = tab->meta;
	while(M){
		nmeta++;
		M = M->next;
	}
	return nmeta;
}

static const char motab_empty[] = "";


const char *motab_find_meta_row(MotabData *tab, const char *tag){
	assert(tab);
	char s[MAXCHARS] = "";
	if(tab->meta){
		MotabMetaData *M = tab->meta;
		while(M){
			// get the tag for this row:
			assert(M->row);
			char *c = &(M->row[0]);
			char *d = &(s[0]);
			while(*c!='\0' && *c != ','){
				*d++ = *c++;
			}
			*d = '\0';
			MSG("Found tag '%s'",s);
			if(strcmp(s,tag)==0){
				if(*c == '\0')return motab_empty;
				else{
					++c;
					MSG("For tag '%s', row = '%s'",tag,c);
					return c;
				}
			}
			M = M->next;
		}
	}
	return NULL;
}

/* you must free the string returned by this function */
static char *get_field(const char *row,int ind){
	assert(ind >= 0);
	assert(row);
	char s[MAXCHARS] = "";
	const char *c = &(row[0]);
	char *d = &(s[0]);
	int i = 0;
	while(*c != '\0'){
		MSG("Copying '%c'",*c);
		*d++ = *c++;
		if(*c == ',' || *c == '\0'){
			*d = '\0';
			MSG("Got '%s'",s);
			if(i == ind){
				MSG("Got match '%s' for field %d",s,i);
				return newcopy(s);
			}
			MSG("Moving to next field");
			i++;
			d = &(s[0]);
			if(*c != '\0')c++;
		}
	}
	MSG("Not found");
	return NULL;
}


char *motab_get_col_units(MotabData *tab, const char *label){
	assert(tab);
	MSG("Searching for units of col '%s'",label);
	const char tag[] = "TABLEUNITS";
	const char *row = motab_find_meta_row(tab,tag);
	if(!row){
		ERR("Invalid tag '%s'",tag);
		return NULL;
	}
	int col = motab_find_col_by_label(tab,label);
	if(-1==col){
		ERR("Invalid column label '%s'",label);
		return NULL;
	}
	MSG("Getting field %d in row '%s'",col,row);
	char *field = get_field(row,col);
	MSG("Field is '%s'",field);
	if(NULL == field){
		ERR("Field %d not found in '%s'",col,row);
		free(field);
		return NULL;
	}
	return field;
}

int motab_find_col_by_label(MotabData *tab, const char *label){
	const char *row;
	row = motab_find_meta_row(tab,"TABLELABELS");
	if(row == NULL){
		return -1;
	}
	//MSG("Got row '%s'",row);
	char s[MAXCHARS] = "";
	const char *c = &(row[0]);
	char *d = &(s[0]);
	int i = 0;
	while(*c != '\0'){
		//MSG("copying char '%c'",*c);
		*d++ = *c++;
		if(*c == ',' || *c == '\0'){
			*d = '\0';
			MSG("Found label %d '%s'",i,s);
			if(strcmp(s,label)==0){
				MSG("Match!");
				return i;
			}
			d = &(s[0]);
			if(*c != '\0')c++;
			i++;
		}
	}
	MSG("No match");
	return -1;
}


int motab_check_timestep(MotabData *tab, double *step_return){
	assert(tab);
	int time_col = motab_find_col_by_label(tab,"time");
	char *units = motab_get_col_units(tab,"time");
	if(strcmp(units,"s") != 0){
		ERR("Units for column 'time' are not 's' as expected. Got '%s' instead.",units);
		free(units);
		return 1;
	}
	if(tab->nrows < 2){
		ERR("Table does not have two or more rows");
		return 2;
	}
	double delta = MOTAB_VAL(tab,1,time_col) - MOTAB_VAL(tab,0,time_col);
	double t;
	for(int r=2;r < tab->nrows; ++r){
		t = MOTAB_VAL(tab,r,time_col);
		MSG("t = %lf",t);
		if(delta != t - MOTAB_VAL(tab,r-1,time_col)){
			ERR("Incorrect time increment at t = %lf",t);
			return 3;
		}
	}
	if(step_return)*step_return = delta;
	return 0;
}


// vim: ts=4:sw=4:noet:tw=
