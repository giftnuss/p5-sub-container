  package Chest::Lock
# *******************
; our $VERSION='0.001'
# ********************
; use strict; use warnings

; use base 'Chest'

; use Carp
; use Data::Dumper

################################################################################

# Chest Entry Construction

; sub PERFORM () { 0 } # key to save the actual chest function
                       #
; sub REQUIRE () { 1 } # key under which a function to check input
                       # parameters can be registered
                       #
; sub ENSURE  () { 2 } # key under which a function to check the return value
                       # can be registered

; our @AACC = qw/PERFORM REQUIRE ENSURE/

; sub import
    { my ($self,@args) = @_
    ; while(my ($k,$v) = splice(@args,0,2))
        { if($k eq 'as' and $v eq 'superclass')
            { my $target = caller
            ; no strict 'refs'
            ; my @acc = @{join('::',$self,'AACC')}
            ; $self->_export_acc($target,\@acc)
            }        
        }
    }
    
; sub _export_acc
    { my ($self,$target,$acc) = @_
    ; no strict 'refs'
    ; for my $acc (@$acc)
        { *{join("::",$target,$acc)} = \&{$acc}
        }
    }
    
################################################################################

# Chest Methods

; sub insert_always
    { my ($self,$key,$code,@args)=@_
    ; my $entry=$self->{$key} || []
    ; my @parts=qw/perform require ensure/

    ; for ( 0..$#parts )
        { if( defined($code->{$parts[$_]}) )
            { $entry->[$_] = &{$code->{$parts[$_]}}(@args)
            ; unless( ref $entry->[$_] eq 'CODE' )
                { print Dumper($entry)
                ; croak uc($_)." is no sub"
                }
            }
        }
    ; return $self->{$key}=$entry
    }

; sub exists
    { my ($self,$key)=@_
    ; CORE::exists $self->{$key}
    }

; sub take
    { my ($self,$key,@par)=@_
    ; unless( $self->exists($key)  )
        { carp "$key isn't in the chest."
        ; return undef
        }
    ; unless( ref $self->{$key}->[PERFORM] eq "CODE" )
        { carp "no code to perform for key $key." }

    ; if( CORE::exists($self->{$key}->[REQUIRE]) )
        { unless( &{$self->{$key}->[REQUIRE]}(@par) )
            { carp "Failure during check of arguments for $key."
            ; return undef
        }   }

    ; return &{$self->{$key}->[PERFORM]}(@par)
        unless CORE::exists($self->{$key}->[ENSURE])

    ; if( wantarray )
        { my @result = &{$self->{$key}->[PERFORM]}(@par)
        ; if( CORE::exists($self->{$key}->[ENSURE]) )
            { unless( &{$self->{$key}->[ENSURE]}(@result) )
                { carp "Failure during check of result from $key."
                ; return ()
                }
            } ; # print($key,"ARRAY\n")
        ; return @result
        }
      else
        { my $result = &{$self->{$key}->[PERFORM]}(@par)
        ; if( CORE::exists($self->{$key}->[ENSURE]) )
            { unless( &{$self->{$key}->[ENSURE]}($result) )
                { carp "Failure during check of result from $key."
                ; return undef
                }
            } #; print($key,"SCALAR\n")
        ; return $result
        }
    }

; 1

__END__

=head1 NAME

Chest::Lock

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 Special import method for subclasses


