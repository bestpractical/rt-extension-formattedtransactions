use lib '.';
use inc::Module::Install;

RTx     'RT-Extension-FormattedTransactions';
license 'gpl_2';
repository 'https://github.com/bestpractical/rt-extension-formattedtransactions';

requires_rt '4.4.0';
rt_too_new '4.6.0';

requires 'Text::WordDiff';

sign;
WriteAll;
