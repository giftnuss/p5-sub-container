
use Test::More tests => 3;

BEGIN {
  use_ok( 'Chest' )
}

  #; use Chest
  
  ; my $chest=new Chest
  
  ; sub hello 
      { $val={ 'de' => 'hallo', 'en' => 'hello' }->{shift()} 
      ; sub { my $pers=shift; ucfirst($val)." ".$pers } }
            
  ; $chest->insert("hello world",sub{hello("de")});
  
  #; print $chest->take("hello world","Welt");
    
; is($chest->take("hello world","Welt"),"Hallo Welt")

; $chest->insert("name",sub{my $a=$_[0];sub{$a}},"name")

; is($chest->take("name"),"name")