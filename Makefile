

readme:
	perl -MPod::Markdown -e 'Pod::Markdown->new->filter(@ARGV)' lib/Repeat/Until.pm > README.md
