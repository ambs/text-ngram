/* -*- C -*- */
#define PERL_NO_GET_CONTEXT

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

void _process_buffer(SV* sv, unsigned int window, HV** counts_hv) {
    HV*    counts;
    STRLEN len;
    char*  buffer = SvPV(sv, len);
    unsigned int windows = (len < window) ? 0 : len - window + 1;

    if (!counts_hv || !*counts_hv)
        *counts_hv = (HV*)sv_2mortal((SV*)newHV());
    counts = *counts_hv;

    while (windows--) {
        sv_inc(*hv_fetch(counts, buffer++, window, TRUE));
    }
}

MODULE = Text::Ngram            PACKAGE = Text::Ngram

PROTOTYPES: DISABLE

HV*
_process_buffer(buffer, window)
    SV*          buffer
    unsigned int window
    CODE:
    {
        HV* newhv = NULL;
        _process_buffer(buffer, window, &newhv);
        RETVAL=newhv;
    }
    OUTPUT:
        RETVAL

void
_process_buffer_incrementally(buffer, window, hash)
    SV*          buffer
    unsigned int window
    HV* hash
    CODE:
        _process_buffer(buffer, window, &hash);
