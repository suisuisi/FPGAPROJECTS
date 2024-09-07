#******************************************************************************
# Avnet-Silica Demo
# Author: Marco Höfle
# Date: 2024-03-13
# Purpose: creates xsa file fot Vitis and PetaLinux
#******************************************************************************

set BUILD_DIR .
set XSA_DIR $BUILD_DIR
set PROJ_NAME "avs-au15p"
set PROJ_PATH $BUILD_DIR/$PROJ_NAME.xpr

open_project $PROJ_PATH
write_hw_platform -fixed -force -include_bit -file $XSA_DIR/$PROJ_NAME.xsa

