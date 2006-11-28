use Module::Build;
# See perldoc Module::Build for details of how this works

# this is more a reminder to myself how easy it was to extend the functionality

my $class = Module::Build->subclass
    (
     class => 'My::Builder',
     code => q{
      use File::Copy::Recursive;
     
      sub ACTION_copies {
        File::Copy::Recursive::dircopy('lib','../../Visconti-2006/lib') 
      }
     },
    );

$class->new
    ( module_name     => 'Chest',
      dist_author     => 'Sebastian Knapp <sk@computer-leipzig.com>',
      license         => 'perl',
      create_makefile_pl => 'traditional',
      dist_abstract   => 'Class to store procedures in a hash.'
    )->create_build_script;
