package Text::Ngram;

use 5.006;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw( ngram_counts add_to_counts) ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

our $VERSION = '0.04';

require XSLoader;
XSLoader::load('Text::Ngram', $VERSION);

# Preloaded methods go here.

sub clean_buffer {
    my $buffer = lc shift;
    $buffer =~ s/\s+/ /g;
    $buffer =~ s/[^a-z ]+/ \xff /g;
    return $buffer;
}

sub ngram_counts {
    my ($buffer, $width) = @_;
    my $href = process_buffer(clean_buffer($buffer), $width||5);
    for (keys %$href) { delete $href->{$_} if /\xff/ }
    return $href;
}

sub add_to_counts {
    my ($buffer, $width, $href) = @_;
    if (!defined $width  or !$width) {
        my ($key, undef) = each %$href; # Just gimme a random key
        $width = length $key || 5;
    }
    process_buffer_incrementally(clean_buffer($buffer), $width, $href);
    for (keys %$href) { delete $href->{$_} if /\xff/ }
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Text::Ngram - Basis for n-gram analysis

=head1 SYNOPSIS

  use Text::Ngram qw(ngram_counts add_to_counts);
  my $text   = "abcdefghijklmnop";
  my $hash_r = ngram_counts($text, 3); # Window size = 3
  # $hash_r => { abc => 1, bcd => 1, ... }

  add_to_counts($more_text, 3, $hash_r);

=head1 DESCRIPTION

n-Gram analysis is a field in textual analysis which uses sliding window
character sequences in order to aid topic analysis, language
determination and so on. The n-gram spectrum of a document can be used
to compare and filter documents in multiple languages, prepare word
prediction networks, and perform spelling correction.

The neat thing about n-grams, though, is that they're really easy to
determine. For n=3, for instance, we compute the n-gram counts like so:

    the cat sat on the mat
    ---                     $counts{"the"}++;
     ---                    $counts{"he "}++;
      ---                   $counts{"e c"}++;
       ...

This module provides an efficient XS-based implementation of n-gram
spectrum analysis.

There are two functions which can be imported:

    $href = ngram_counts($text[, $window]);

This first function returns a hash reference with the n-gram histogram 
of the text for the given window size. If the window size is omitted,
then 5-grams are used. This seems relatively standard.

    add_to_counts($more_text, $window, $href)

This incrementally adds to the supplied hash; if C<$window> is zero or
undefined, then the window size is computed from the hash keys.

=head1 Important note on text preparation

Most of the published algorithms for textual n-gram analysis assume that
the only characters you're interested in are alphabetic characters and
spaces. So before the text is counted, the following preparation is
made.

All characters are lowercased; (most papers use upper-casing, but that
just feels so 1970s) punctuation and numerals are replaced by stop
characters flanked by blanks; multiple spaces are compressed into a
single space.

After the counts are made, n-grams containing stop characters are
dropped from the hash.

If you prefer to do your own text preparation, use the internal routines
C<process_text> and C<process_text_incrementally> instead of
C<count_ngrams> and C<add_to_counts> respectively.

=head1 SEE ALSO

Cavnar, W. B. (1993). N-gram-based text filtering for TREC-2. In D.
Harman (Ed.), I<Proceedings of TREC-2: Text Retrieval Conference 2>.
Washington, DC: National Bureau of Standards.

Shannon, C. E. (1951). Predication and entropy of printed English.
I<The Bell System Technical Journal, 30>. 50-64.

Ullmann, J. R. (1977). Binary n-gram technique for automatic correction
of substitution, deletion, insert and reversal errors in words.
I<Computer Journal, 20>. 141-147.

=head1 AUTHOR

Maintained by Jose Castro, C<cog@cpan.org>.
Originally created by Simon Cozens, C<simon@cpan.org>.

=head1 COPYRIGHT AND LICENSE

Copyright 2004 by Jose Castro
Copyright 2003 by Simon Cozens

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
