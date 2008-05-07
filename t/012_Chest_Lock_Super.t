
; use strict; use warnings
; use Test::More tests => 4


; BEGIN { package C::T
        ; Test::More::use_ok('Chest::Lock',as => 'superclass')
        }

; package main
; is(C::T::PERFORM(),0)
; is(C::T::REQUIRE(),1)
; is(C::T::ENSURE() ,2)

