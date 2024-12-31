target = "altera"
action = "synthesis"

syn_family  = "Cyclone IV E"
syn_device  = "EP4CE6"
syn_grade   = "C8"
syn_package = "E22"

syn_top     = "fir_filter"
syn_project = "fir_filter"

syn_tool = "quartus"

quartus_preflow = "quartus_preflow.tcl"

files = [
    "quartus_preflow.tcl",
    "fir_filter.sdc",
]

modules = {
    "local" : [
        "../",
    ]
}