set IP_DIR [file dirname [file normalize [info script]]]
set SRC_DIR ${IP_DIR}
set WORK_DIR [pwd]

set VERSION "0.12"
set CORE_DESCRIPTION "AVS Version IP"
set CORE_VENDOR "Avnet-Silica"
set VERSION_FILE version.h

proc gen_version { file_name } {
    puts "Creating version file $file_name"

    set tool_version [version -short]
    set systemTime [clock seconds]

    set bld_time [clock format $systemTime -format %H:%M:%S]
    set bld_date [clock format $systemTime -format %d-%m-%y]
    set builder [exec whoami]

    set git_hash [exec git rev-parse HEAD]
    set git_tag [exec git describe --always --tag]
    set git_branch [exec git rev-parse --abbrev-ref HEAD]

    set fid [open $file_name w]
    puts $fid "\#define TOOL_VERSION \"$tool_version\""
    puts $fid "\#define BUILT \"$bld_time $bld_date\""
    puts $fid "\#define BUILDER \"$builder\""
    puts $fid "\#define GIT_HASH \"$git_hash\""
    puts $fid "\#define GIT_TAG \"$git_tag\""
    puts $fid "\#define GIT_BRANCH \"$git_branch\""
    close $fid
} 


gen_version $WORK_DIR/$VERSION_FILE

open_project avs_version
set_top avs_version
add_files $SRC_DIR/avs_version.cpp -cflags "-I${WORK_DIR}"
add_files $VERSION_FILE

open_solution "solution1"
set_part {xcau15p-ffvb676-2-e}

create_clock -period 10 -name default
config_export -description $CORE_DESCRIPTION -format ip_catalog -rtl vhdl -vendor $CORE_VENDOR -version $VERSION
csynth_design
export_design -rtl vhdl -format ip_catalog -description $CORE_DESCRIPTION -vendor $CORE_VENDOR -display_name "AVS hls version ip" -version $VERSION

exit
