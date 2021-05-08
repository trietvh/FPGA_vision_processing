set_global_assignment -entity "HDMI_PLL" -library "lib_HDMI_PLL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "HDMI_PLL" -library "lib_HDMI_PLL" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "HDMI_PLL" -library "lib_HDMI_PLL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_HDMI_PLL" -name SPD_FILE [file join $::quartus(sip_path) "HDMI_PLL.spd"]

set_global_assignment -library "lib_HDMI_PLL" -name MISC_FILE [file join $::quartus(sip_path) "HDMI_PLL_sim/HDMI_PLL.vo"]
