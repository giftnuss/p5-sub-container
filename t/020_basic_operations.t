
use Test::More tests => 4;

BEGIN {
  use_ok( 'Chest' )
}

  #; use Chest
  
  ; my $chest=new Chest
  
  ; sub hello 
      { my $val={ 'de' => 'hallo', 'en' => 'hello' }->{shift()} 
      ; sub { my $pers=shift; ucfirst($val)." ".$pers } }
            
  ; my $sub2=$chest->insert("hello world",sub{hello("de")});
  
  #; print $chest->take("hello world","Welt");
    
  ; is($chest->take("hello world","Welt"),"Hallo Welt")
  ; is($sub2->('Deutschland'),"Hallo Deutschland")

; $chest->insert("name",sub{my $a=$_[0];sub{$a}},"name")

; is($chest->take("name"),"name")