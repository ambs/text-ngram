#!/usr/bin/perl

use Text::Ngram qw/add_to_counts/;
use Data::Dumper;

my $occs = {};

while (<>) {
  add_to_counts($_, 3, $occs);
}

print Dumper($occs);
