project( 'gunit',
         'cpp',
         default_options: [ 'c_std=c11', 'cpp_std=c++11' ] )

sources = [
    'src/gmock-all.cc',
    'src/gtest-all.cc',
]

includes = include_directories( 'include' )

deps = [
    dependency( 'threads' )
]

shared_library( 'gunit',
                sources,
                include_directories : includes,
                dependencies : deps )
