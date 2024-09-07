set CUR_DIR [pwd]
set XSA_FILE $CUR_DIR/../../vivado/build/prj/avs-au15p.xsa
set WS_DIR $CUR_DIR
set PFM_NAME pfm_bobbyb
set SRC_DIR_APP $CUR_DIR/../bobbyb


puts "INFO: Building the Vitis Workspace at $WS_DIR."


setws $WS_DIR


proc gen_platform {args} {
	variable PFM_NAME
	variable XSA_FILE
	variable WS_DIR

	platform create -name $PFM_NAME -desc "microblaze vitis platform" -hw $XSA_FILE -proc microblaze_0 -os standalone
	platform write
	platform generate
	platform active $PFM_NAME
}



proc gen_app {config} {
	variable PFM_NAME
	variable SRC_DIR_APP

	app create -name bobbyb -platform $PFM_NAME -lang C -template {Empty Application(C)}
	app config -name bobbyb build-config $config
	app config -name bobbyb include-path "\${workspace_loc:/\${ProjName}/src}"
	file delete -force -- src
	importsources -name bobbyb -path $SRC_DIR_APP -soft-link  -linker-script -target-path .
	app config -name bobbyb linker-script "\${workspace_loc:/src/lscript.ld}"
	app build -name bobbyb
}

gen_platform

