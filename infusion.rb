
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.1"

define_package "libvorbis-1.3.3" do |package|
	package.depends = ["libogg"]

	package.build(:all) do |platform, environment|
		environment.use in: package.source_path do |config|
			Dir.chdir(package.source_path) do
				Commands.run("make", "clean") if File.exist? "Makefile"
				
				# The default configure has problems when compiling with multiple architectures because of the following option..
				# so we remove it forcefully.
				Commands.run("sed", "-i", "-e", "s/-force_cpusubtype_ALL//g", "configure", "configure.ac")
				
				Commands.run("./configure",
					"--prefix=#{platform.prefix}",
					"--disable-dependency-tracking",
					"--enable-shared=no",
					"--enable-static=yes", 
					*config.configure
				)
				
				Commands.run("make install")
			end
		end
	end
end
