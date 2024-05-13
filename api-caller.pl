#!/usr/bin/perl
use strict;
use warnings;

use LWP::UserAgent;
use HTTP::Request::Common;

# URL to which you want to make the POST request
my $url = 'http://calsdxtok01.sdx.payroc.dev/fcgi-bin/tokenator.fcgi';

# Form data to be sent in the POST request
my %form_data = (
    'TOKEN_ACTION'       => 'ADD',
    'COMPANY_ID'         => 'BLUEPAYQA',
    'TERMINAL_ID'        => 'BPQATEST',
    'PROGRAM_ID'         => 'TEST1',
    'TOKEN'              => 'QAPREAUTH202402091433',
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
    'DEBUG'              => 'Y',
);

# Create a user agent object
my $ua = LWP::UserAgent->new;

# Make the POST request with form data
my $response = $ua->request(
    POST $url,
    Content_Type => 'form-data',
    Content      => \%form_data,
);

# Check if the request was successful
if ( $response->is_success ) {
    print "POST request successful:\n", $response->decoded_content, "\n";
}
else {
    print "Error:", $response->status_line, "\n";
}
