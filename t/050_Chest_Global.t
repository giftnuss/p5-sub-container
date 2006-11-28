
use Test::More tests => 2;

BEGIN {
  use_ok( 'Chest::Global' )
}

insert Chest::Global ('t1', sub{ sub{ 1 } });

ok( take Chest::Global('t1') == 1 );
