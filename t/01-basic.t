# vim:ft=perl
use Test::More tests => 5;
use_ok("Text::Ngram");

my $text = "abcdefg1235678hijklmnop";
my $hash = Text::Ngram::ngram_counts($text, 3);
is_deeply($hash, {
          'abc' => 1,
          'bcd' => 1,
          'cde' => 1,
          'def' => 1,
          'efg' => 1,
          'fg ' => 1,
          ' hi' => 1,
          'hij' => 1,
          'ijk' => 1,
          'jkl' => 1,
          'klm' => 1,
          'lmn' => 1,
          'mno' => 1,
          'nop' => 1,
         }, "Simple test finds all ngrams");
Text::Ngram::add_to_counts("abc", 3, $hash);
is($hash->{abc}, 2, "Simple incremental adding works");
is($hash->{bcd}, 1, "Without messing everything else up");
Text::Ngram::add_to_counts("abc", undef, $hash);
is($hash->{abc}, 3, "We can guess the window size");
