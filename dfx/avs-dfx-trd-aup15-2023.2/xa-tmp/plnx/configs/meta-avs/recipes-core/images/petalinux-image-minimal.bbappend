DESCRIPTION = "Image definition for Avnet Silica TRDs"
LICENSE = "MIT"

# append what is already defined by petalinux (meta-petalinux and build/conf/plnxtool.conf)



IMAGE_INSTALL:append = "\
	i2c-tools \
	udmabuf \
	libgpiod \
	libgpiod-tools \
	dfx-demo \
"

