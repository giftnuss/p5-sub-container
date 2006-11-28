
; use strict
; use warnings

; package Chest::Global
; use Chest

# Changelog
# 
# 2005/09/27 0.01 Initial Version
#
# 2005/10/11 0.02
#   - add the possibility to change method names
#   - add a simple constructor to store it as an object
#
# 2005/10/14 0.03
#   - make the constructor more flexible
# 

; our $VERSION='0.031'
; our $CHEST

; sub import
    { my $class=shift
    ; return if defined $CHEST
    ; my @m=('insert','insert_always','take','exists','show_chest')
    ; my %opt=%{shift() || {}}
    ; $CHEST=new Chest
    ; for my $method ( @m )
        { my $call=$opt{$method} || $method
        ; eval qq~ sub $call { shift; our \$CHEST->$method(\@_) }~ 
        }
    }
    
; sub new
    { my $pack=shift
    ; my $type=shift
    ; my $class = ref $pack || $pack
    ; return bless \$pack,$class if !$type || $type eq 'SCALAR'
    ; return bless {},$class if $type eq 'HASH'
    ; return bless {},$class if $type eq 'ARRAY'
    ; return bless $type,$class    
    }

; 1

__END__

=head1 NAME

Chest::Global - use it as a global chest.

=head1 SYNOPSIS
  
  use Chest::Global;

  Chest::Global->insert('Function No. 1',sub{sub{print "hello world!\n"}});
  Chest::Global->take('Function No. 1');

=head1 DESCRIPTION

Creates a single chest to insert and take methods from.

=head1 USAGE

=head2 import

Initialize the global object and defines the method names. Default is the same
as in L<Chest>. You can change them with a hash reference with original method 
names as keys and new names as values.

Example:

  ; use Chest::Global { take => 'execute', insert => 'place' }

=head1 SEE ALSO

L<Chest>

=head1 AUTHOR

Sebastian Knapp 

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Sebastian Knapp 

This library is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut



