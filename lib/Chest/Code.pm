  package Chest::Code
# *******************
; our $VERSION='0.01'
# *******************
; use base 'Chest'
; use strict

; sub CODEREF () { 0 }
; sub CODESTR () { 1 }
; sub CODEARG () { 2 }
    
; { my %messages=

    ( 'NO STRING ARG' => 'Argument for evaled insert must be a string, key: %s'
    , 'CODE EXISTS <' => "There already code in the chest for key '%s'."
    )
    
  ; add Chest::Error ($_,$messages{$_}) foreach keys %messages
  } 
    
; sub insert
    { my ($self,$key,$code,@args)=@_
    ; return $self->SUPER::insert($key,$code,@args) if ref $code
    ; return if $self->carp_existence($key)
    ; $self->{$key}->[CODESTR]=$code
    ; $self->{$key}->[CODEARG]=\@args
    ; return sub { $self->take($key,@_) } if defined wantarray
    }

; sub insert_always
    { my ($self,$key,$code,@args)=@_
    ; return $self->SUPER::insert_always($key,$code,@args) if ref $code
    ; $self->{$key}->[CODESTR]=$code
    }

; sub insert_evaled
    { my ($self,$key,$code,@args)=@_
    ; $self->croak('NO STRING ARG',$key) if ref $code
    ; return if $self->carp_existence($key)
    ; $self->insert_always_evaled($key,$code,@args)
    }
    
; sub insert_always_evaled
    { my ($self,$key,$code,@args)=@_
    ; $self->croak('NO STRING ARG',$key) if ref $code
    ; $self->{$key}->[CODESTR]=$code
    ; $self->SUPER::insert_always($key,eval "sub { $code }",@args)
    }
    
; sub codestring
    { my ($self,$key)=@_
    ; $self->{$key}->[CODESTR]
    }

; sub take
    { my ($self,$key,@args)=@_
    ; unless($self->{$key}->[CODEREF])
        { my $code = $self->codestring($key)
        ; my $sub  = $self->SUPER::insert_always
            ( $key, eval("sub { $code }"), @{$self->{$key}->[CODEARG]} )
        }
    ;  return $self->{$key}->[CODEREF]->(@args)
    }
    
; 1

__END__
    
=head1 NAME

Chest::Code - store the codestring with the subroutine

=head1 SYNOPSIS


=head1 DESCRIPTION


