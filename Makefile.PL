use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'Text::Ngram',
    'VERSION_FROM'	=> 'lib/Text/Ngram.pm',
    'PREREQ_PM'		=> {},
    ($] >= 5.005 ? 
      (ABSTRACT_FROM => 'lib/Text/Ngram.pm', 
       AUTHOR     => 'Alberto Simoes <ambs@cpan.org>') : ()),
    'LIBS'		=> [''],
    'DEFINE'		=> '',
    'INC'		=> '-I.',
);
