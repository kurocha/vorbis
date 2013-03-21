
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.6"

define_target "vorbis" do |target|
	target.build do |environment|
		build_external(package.path, "libvorbis-1.3.3", environment) do |config, fresh|
			if fresh
				Commands.run("sed", "-i", "-e", "s/-force_cpusubtype_ALL//g", "configure", "configure.ac")
				
				Commands.run("./configure",
					"--prefix=#{config.install_prefix}",
					"--disable-dependency-tracking",
					"--enable-shared=no",
					"--enable-static=yes", 
					*config.configure
				)
			end
			
			Commands.make_install
		end
	end
	
	target.depends :platform
	target.depends "Library/ogg"
	
	target.provides "Library/vorbis" do
		append linkflags ["-lvorbis", "-lvorbisfile"]
	end
end
