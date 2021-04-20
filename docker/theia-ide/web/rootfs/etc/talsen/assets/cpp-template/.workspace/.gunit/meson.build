
project( 'talsen-kata',
         'cpp',
         default_options : [ 'c_std=c11', 'cpp_std=c++17' ] )

cpp_compiler = meson.get_compiler('cpp')

opt_exe_name = get_option( 'exe_name' )
opt_gunit_lib_dir = get_option( 'gunit_lib_dir' )
opt_cpp_flags_default = get_option( 'x_cpp_flags_default' )
opt_cpp_flags_focus = get_option( 'x_cpp_flags_focus' )

deps = [
    dependency( 'threads' ),
    cpp_compiler.find_library( 'gunit', dirs : opt_gunit_lib_dir ),
]

includes = include_directories( 'src' )

sources = [
# sources
]

cpp_args = opt_cpp_flags_default + opt_cpp_flags_focus

executable( opt_exe_name,
            sources,
            cpp_args : cpp_args,
            dependencies :  deps,
            include_directories : includes,
            link_args : cpp_args,
            )
