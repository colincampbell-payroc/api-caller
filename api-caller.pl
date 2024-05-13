#!/usr/bin/perl
use strict;
use warnings;

use Config::Simple;
use HTTP::Request::Common;
use LWP::UserAgent;

my $cfg = new Config::Simple('conf/app.cfg') or die "Unable to open conf/app.cfg: $!";

my $url     = $cfg->param('url');
my $counter = $cfg->param('counter');

my %form_data = (
    'TOKEN_ACTION'       => 'ADD',
    'COMPANY_ID'         => 'BLUEPAYQA',
    'TERMINAL_ID'        => 'BPQATEST',
    'PROGRAM_ID'         => 'TEST1',
    'TOKEN'              => 'QAPREAUTH20240209' . $counter,
    'CARD_TYPE'          => 'MCRD',
    'CARD_PRODUCT'       => 'MC',
    'END_DATE'           => '21001230',
    'EXP'                => '3012',
    'LAST4'              => '1234',
    'START_DATE'         => '19991231',
    'TOKEN_REF'          => '',
    'CLIENT_ID'          => '',
    'PAN_UPDATE_ALLOWED' => 'N',
    'SINGLE_USE_TOKEN'   => 'Y',
    'TOKEN_CARD_CHECK'   => 'true',
    'TOKEN_TYPE'         => 'CardNumber',
    'MASKED_VALUE'       => '',
    'PRIVATE'            => '6011208880010601',
    'USER_ID'            => 'testuser',
    'PASS'               => 'password',
    'DEBUG'              => 'N',
);

my @intervals = (
    0,
    15,
    30,
    45,
    60,     # 1 hour
    75,
    90,
    105,
    120,    # 2 hours
    135,
    150,
    165,
    180     # 3 hours
);

open( my $fh, '>', 'app.log' ) or die $!;
$fh->autoflush;

foreach my $interval (@intervals) {
    print $fh "Waiting $interval minutes...\n";

    sleep $interval * 60;

    $form_data{TOKEN} = 'QAPREAUTH20240209' . $counter;

    my $ua = LWP::UserAgent->new;

    my $response = $ua->request(
        POST $url,
        Content_Type => 'form-data',
        Content      => \%form_data,
    );

    if ( $response->is_success ) {
        print $fh "POST request successful:\n", $response->decoded_content, "\n";
    }
    else {
        print $fh "Error:", $response->status_line, "\n";
    }

    $counter++;
    $cfg->param( 'counter', $counter );
    $cfg->write();
}

print $fh "Finished\n";

close($fh);
