package Crypt::HSXKPasswd::RNG::Data_Entropy;

use parent Crypt::HSXKPasswd::RNG;

# import required modules
use strict;
use warnings;
use Carp; # for nicer 'exception' handling for users of the module
use Fatal qw( :void open close binmode ); # make builtins throw exceptions on failure
use English qw( -no_match_vars ); # for more readable code
use Crypt::HSXKPasswd; # for the error function

# set things up for using UTF-8
use 5.016; # min Perl for good UTF-8 support, implies feature 'unicode_strings'
use Encode qw(encode decode);
use utf8;
binmode STDOUT, ':encoding(UTF-8)';

# try import Data::Entropy::Algorithms
my $_CAN_DATA_ENTROPY = eval{
    require Data::Entropy::Algorithms; # for random number generation
};

# Copyright (c) 2015, Bart Busschots T/A Bartificer Web Solutions All rights
# reserved.
#
# Code released under the FreeBSD license (included in the POD at the bottom of
# HSXKPasswd.pm)

#
# --- 'Constants' -------------------------------------------------------------
#

# version info
use version; our $VERSION = qv('1.1_01');

# utility variables
my $_CLASS = 'Crypt::HSXKPasswd::RNG::Data_Entropy';
my $_MAIN_CLASS = 'Crypt::HSXKPasswd';

#
# --- Constructor -------------------------------------------------------------
#

#####-SUB-#####################################################################
# Type       : CONSTRUCTOR (CLASS)
# Returns    : An object of type Crypt::HSXKPasswd::RNG::Data_Entropy
# Arguments  : NONE
# Throws     : Croaks on invalid invocation and invalid args, or if the module
#              Data::Entropy::Algorithms is not available
# Notes      : 
# See Also   : 
sub new{
    my $class = shift;
    
    # validate the args
    unless(defined $class && $class eq $_CLASS){
        $_MAIN_CLASS->_error('invalid invocation of constructor');
    }
    
    # croak if Data::Entropy::Algorithms is not avaialble
    unless($_CAN_DATA_ENTROPY){
        $_MAIN_CLASS->_error('This RNG module requires Data::Entropy::Algorithms, which is not installed');
    }
    
    # bless and return an empty object
    my $instance = {};
    bless $instance, $class;
    return $instance;
}

#
# --- Public Instance functions -----------------------------------------------
#

#####-SUB-#####################################################################
# Type       : INSTANCE
# Purpose    : Override the parent random_numbers() function and generate
#              random numbers between 0 and 1.
# Returns    : An array of numbers between 0 and 1
# Arguments  : 1) the number of random numbers needed to produce 1 password.
# Throws     : NOTHING
# Notes      : This function will return the number of random numbers needed
#              for a single password.
# See Also   :
sub random_numbers{
    my $self = shift;
    my $num = shift;
    
    # validate the args
    unless(defined $self && $self->isa($_CLASS)){
        $_MAIN_CLASS->_error('invalid invocation of an instance method');
    }
    unless(defined $num && $num =~ m/^\d+$/sx && $num >= 1){
        $_MAIN_CLASS->_error('invalid args - the number of random numbers needed per password must be a positive integer');
    }
    
    # generate the random numbers
    my @ans = ();
    my $num_to_generate = $num;
    while($num_to_generate > 0){
        push @ans, Data::Entropy::Algorithms::rand();
        $num_to_generate--;
    }
    
    # return the random numbers
    return @ans;
}

1; # because Perl is just a little bit odd :)