DESTINATION="build.deb"
PWD:=$(shell pwd)


all:

	mkdir --parents $(PWD)/build

	wget --directory-prefix=$(PWD)/build --continue --content-disposition https://deac-ams.dl.sourceforge.net/project/pixelitor/4.2.3/Pixelitor-4.2.3.jar

	wget --no-check-certificate --output-document=$(PWD)/build/build.rpm --continue https://forensics.cert.org/centos/cert/8/x86_64/jdk-12.0.2_linux-x64_bin.rpm
	cd $(PWD)/build && rpm2cpio build.rpm | cpio -idmv && cd ..

	mkdir --parents $(PWD)/build/AppDir
	mkdir --parents $(PWD)/build/AppDir/application
	mkdir --parents $(PWD)/build/AppDir/jre

	cp --recursive --force $(PWD)/build/*.jar $(PWD)/build/AppDir/application
	cp --recursive --force $(PWD)/AppDir/* $(PWD)/build/AppDir
	cp --recursive --force $(PWD)/build/usr/java/jdk-*/* $(PWD)/build/AppDir/jre

	chmod +x $(PWD)/build/AppDir/AppRun

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage $(PWD)/build/AppDir $(PWD)/Pixelitor.AppImage
	chmod +x $(PWD)/Pixelitor.AppImage
	make clean

clean:
	rm -rf $(PWD)/*.jar
	rm -rf $(PWD)/build
