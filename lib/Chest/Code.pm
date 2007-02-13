  package Chest::Code
; use base 'Chest'

; use strict; our $VERSION='0.01'

; use constant CHEST => 0
; use constant CODE  => 1

; sub new
    { my ($class)=@_
    ; $class = ref $class if ref $class
    ; bless [ new Chest(), {} ], $class
    }
    
; sub exists
    { my ($self,$key)=@_
    ; $self->[CHEST]->exists($key) || CORE::exists($self->[CODE]->{$key})
    }
    
; { my %messages=

    ( 'NO STRING ARG' => 'Argument for evaled insert must be a string, key: %s'
    , 'CODE EXISTS <' => "There already code in the chest for key '%s'."
    )
    
  ; add Chest::Error ($_,$messages{$_}) foreach keys %messages
  } 
    
; sub insert
    { my ($self,$key,$code,@args)=@_
    ; return $self->[CHEST]->insert($key,$code,@args) if ref $code
    

; sub insert_always
    { my ($self,$key,$code,@args)=@_
    ; return $self->[CHEST]->insert_always($key,$code,@args) if ref $code

; sub insert_evaled
    { my ($self,$key,$code,@args)=@_
    ; $self->croak('NO STRING ARG',$key) if ref $code
    ; if( $self->exists($key) )
        { $self->carp('KEY EXISTS <',$key)
	; return
	}
    ; $self->insert_always_evaled($key,$code,@args)
    }
    
; sub insert_always_evaled
    { my ($self,$key,$code,@args)=@_
    ; $self->croak('NO STRING ARG',$key) if ref $code
    
; sub take
    { my ($self,$key,@args)=@_
    ; $self->{'chest'}->take($key,@args) if $self->{'chest'}->exists($key)

    
    
    