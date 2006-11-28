
; use Test::More tests => 1

; use Chest::Global { take => 'execute', insert => 'place' }

; place Chest::Global ('t1', sub{ sub{ 1 } });

; ok( execute Chest::Global('t1') == 1 );