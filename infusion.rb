
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.5"

define_package "libvorbis" do |package|
	package.install do |environment|
		environment.use in:(package.path + 'libvorbis-1.3.3') do |config|
			Commands.run("make", "clean") if File.exist? "Makefile"
				
			# The default configure has problems when compiling with multiple architectures because of the following option.. so we remove it forcefully :D
			Commands.run("sed", "-i", "-e", "s/-force_cpusubtype_ALL//g", "configure", "configure.ac")
				
			Commands.run("./configure",
				"--prefix=#{config.install_prefix}",
				"--disable-dependency-tracking",
				"--enable-shared=no",
				"--enable-static=yes", 
				*config.configure
			)
				
			Commands.run("make", "install")
		end
	end
	
	package.depends :system
	package.depends "Library/ogg"
	
	package.provides "Library/vorbis" do
		append linkflags ["-lvorbis", "-lvorbisfile"]
	end
end
