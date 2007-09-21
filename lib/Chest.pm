  package Chest
; use strict

; our $VERSION='0.084'

# internal slot selection - this is the base module, 
# only the first of unlimited slots is used.
; sub CODEREF () { 0 }

; sub new
    { my ($class)=@_
    ; $class = ref $class if ref $class
    ; bless {} , $class
    }

# shortcut for existence checking
; sub carp_existence
    { my ($self,$key)=@_
    ; if( $self->exists($key) )
        { local $Carp::CarpLevel; $Carp::CarpLevel++
        ; $self->carp('KEY EXISTS <',$key)
        ; return 1
        }
    ; 0
    }

; sub insert
    { my ($self,$key,$sub,@args)=@_
    ; return if $self->carp_existence($key)
    ; $self->insert_always($key,$sub,@args)
    }

; sub insert_always
    { my ($self,$key,$sub,@args)=@_
    ; unless( ref $sub eq 'CODE' )
        { $self->croak('ARG NO CODE REF',$key); return }
    ; $sub = eval { &$sub( @args ) }
    ; if( $@ )
        { $self->croak('CREATION EXCP',$key,$@); return }
    ; unless( ref $sub eq 'CODE' )
        { $self->croak('NO CODE TO STORE',$key); return } 
    ; $self->{$key}=[ $sub ]
    ; $sub
    }

; sub exists
    { my ($self,$key)=@_
    ; CORE::exists $self->{$key}
    }

; sub take
    { my ($self,$key,@par)=@_
    ; unless( $self->exists($key) )
        { $self->carp("KEY NOT IN CHEST",$key)
        ; return 
        }			   
    ; &{$self->{$key}->[CODEREF]}(@par);
    }

; sub coderef
    { my ($self,$key)=@_
    ; unless( $self->exists($key) )
         { $self->carp("KEY NOT IN CHEST",$key)
         ; return sub { undef }
         }
    ; $self->{$key}->[CODEREF]
    }
    
# immediate evaluation
; sub curry
    { my ($self,$old,$new,@args)=@_
    ; my $code=$self->coderef($old)
    ; $self->insert_always($new,sub{sub{&$code(@args,@_)}})
    }

# lazy evaluation
; sub alias
    { my ($self,$old,$new,@args)=@_
    ; $self->insert_always($new,sub{sub{$self->take($old,@args,@_)}})
    }

; sub show_chest
    { my $self=shift
    ; print STDERR "\n *** CHEST ***"
    ; foreach ( sort keys %{$self} )
        { print STDERR "\n$_" }
    ; print "\n"
    }

# This modul eats it's own potatos.
; package Chest::Error
; our @ISA=qw/Chest/
; {
    my $error=new Chest::Error
  ; sub add
      { my ($pkg,$key,$msg)=@_
      ; $error->insert_always($key,mk_message($msg))
      } 

  ; sub mk_message
      { my ($msg)=@_; sub{sub{sprintf($msg,@_)}} } 

  ; sub error
      { shift(); warn $_[0]; $error->take(@_) }
 
  ; my %messages=

  ( # WARNINGS
    'KEY EXISTS <'  => "Key '%s' is already in the chest. Insert failed."
  , 'KEY NOT EXISTS' => "Key '%s' is not in the chest."
    # FATALS
  , 'CREATION EXCP' => "Executing the coderef for key '%s' failed with error: %s"  
  , 'ARG NO CODE REF' => "Argument for inserting '%s' was not a code ref."
  , 'NO CODE TO STORE' => "There was no code ref to store for key '%s'"
  )

  ; add Chest::Error ($_,$messages{$_}) foreach keys %messages 

  # avoid endless loops because typos in error keys and during startup.
  ; sub carp  { croak(@_) }
  ; sub croak { my ($s,$m,@a)=@_ 
              ; require Carp
              ; Carp::croak "Key '$m' is not in Chest::Error" 
              }
  }

; package Chest
; sub carp
    { my ($self,$key,@args)=@_
    ; require Carp
    ; Carp::carp(Chest::Error->error($key,@args))
    }

; sub croak
    { my ($self,$key,@args)=@_
    ; require Carp
    ; Carp::croak(Chest::Error->error($key,@args))
    }

; 'THE_NAME_IS_A_REFERENCE_TO_MIGHTIEST_CREATURE_ON_THE_DISCWORLD'

__END__

=head1 NAME

Chest - Class to store procedures in a hash

=head1 SYNOPSIS

  ; use Chest
  
  ; my $chest=new Chest
  
  ; sub hello 
      { $val={ 'de' => 'hallo', 'en' => 'hello' }->{shift()} 
      ; sub { my $pers=shift; ucfirst($val)." ".$pers } }
            
  ; $chest->insert("hello world",\&hello("de"))
  
  ; print $chest->take("hello world","Welt")
  
=head1 DESCRIPTION

This is a simple interface to call subroutines by strings. So
it is easy to have longer but readable function calls or totally 
cryptical ones.

=head1 USAGE

=head2 C<new>

A simple Constructor without arguments for a hash based object.

=head2 C<insert>

  ; $chest->insert("name",sub{my $a=$_[0];sub{$a}},"name")

Important is the second method argument. It's used to be a valid 
code reference with another code reference as return value. This 
code ref is then stored under the value from first argument. 
Additional arguments will be used when the second argument is 
executed. If an entry exists under this name, this method does 
nothing. Only a warning is printed via carp method.

=head2 C<insert_always>

Same as above but overwrites existing entries.
Both insert functions return the inserted code ref on success.
croak method is used to throw an exception if there were no
usual code refs.

=head2 C<exists>

Check if an an entry with a given name exists.

=head2 C<take>

Execute a stored subroutine with the given arguments.

=head2 C<croak> and C<carp>

Each method calls his pendant from L<Carp|Carp>. So subclasses
can alternate error handling easy.

=head1 SEE ALSO

=over 3

=item L<Callback>

=item L<Class::Phrasebook|Class::Phrasebook>

=item L<Data::Phrasebook|Data::Phrasebook>

=item L<Dispatch::Declare|Dispatch::Declare> - This module uses 2 exported 
functions to provide a similar functionality.

=back 3

=head1 TODO

Getting feedback and correct all mistakes in code and documentation
is still a todo. 

Documentation for carp and croak.

=head1 AUTHOR

Sebastian Knapp 

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006-2007 by Sebastian Knapp

This library is free software; you can redistribute it and/or modify
it under the same terms as perl itself.

=cut

