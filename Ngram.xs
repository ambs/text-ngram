#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

void process_buffer(char* buffer, int window, HV** counts_hv) {
    HV* counts;
    int balance = window / 2;
    
    if (window & 1)
        balance++;

    if (!counts_hv || !*counts_hv)
        *counts_hv = newHV();

    counts = *counts_hv;

    buffer += balance;
    while (*buffer && *(buffer + balance-2))
        sv_inc(*hv_fetch(counts, buffer++ - balance, window, TRUE));
}

MODULE = Text::Ngram		PACKAGE = Text::Ngram		

HV* 
process_buffer(buffer, window)
    char* buffer
    int   window
    CODE:
    {
        HV* newhv = NULL;
        process_buffer(buffer, window, &newhv);
        RETVAL=newhv;
    }
    OUTPUT:
        RETVAL

void
process_buffer_incrementally(buffer, window, hash)
    char* buffer
    int   window
    HV*   hash
    CODE:
        process_buffer(buffer, window, &hash);
