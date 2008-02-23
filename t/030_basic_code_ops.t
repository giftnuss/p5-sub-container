
use Test::More skip_all => ': sourcecode is incomplete and unused';
plans 4;

BEGIN {
  use_ok( 'Chest::Code' )
}

  #; use Chest
  
  ; my $chest=new Chest::Code
  
  ; sub hello 
      { my $val={ 'de' => 'hallo', 'en' => 'hello' }->{shift()} 
      ; my $perform = "sub { my \$pers=shift; ucfirst('$val').\" \".\$pers }"
      ; my $store = "sub { $perform }"
      ; return $store
      }
            
  ; my $sub2=$chest->insert("hello world",hello("de"))
  
  #; print $chest->take("hello world","Welt");
  
  ; is($chest->take("hello world","Welt"),"Hallo Welt")
  ; is($sub2->('Deutschland'),"Hallo Deutschland")

  ; $chest->insert("name","sub{my \$a=\$_[0];sub{\$a}}","name")
  
  ; use Data::Dumper
  ; print Dumper($chest)

  ; is($chest->take("name"),"name")
    