#!/usr/bin/env bash
#
# Configure LANforge test environment (Chamber View scenario).
# This script does not install test automation dependencies or run tests.
#

# Print commands as they're run
set -x

# 0. CHECK SCRIPT ARGUMENTS
if [[ $# -ne 1 ]]; then
    printf "! DUT configuration file argument not specified\n"
    printf "! usage: $0 DUTCFG\n\n"
    exit 1
fi

DUT_CFG_FILE=$1
if [[ ! -f $DUT_CFG_FILE ]]; then
    printf "! DUT configuration file '$DUT_CFG_FILE' does not exist\n"
    printf "! usage: $0 DUTCFG\n\n"
    exit 1
fi


# 1. LOAD DUT CONFIGURATION FILE
printf "> Loading DUT configuration from file \'$DUT_CFG_FILE\'\n\n"
source $DUT_CFG_FILE


# 2. CREATE/UPDATE NEW DUT
printf "> Creating/Updating Chamber View DUT \'$DUT_NAME\'\n\n"

LF_SCRIPTS=lanforge-scripts
LF_PY_SCRIPTS=$LF_SCRIPTS/py-scripts

# NOTE: Separate SSID option arguments with spaces and ensure the keys are lowercase
python3 $LF_PY_SCRIPTS/create_chamberview_dut.py \
    --lfmgr               $LF_MANAGER \
    --dut_name            $DUT_NAME \
    --ssid                "ssid_idx=0 ssid=$DUT_2G_SSID security=$DUT_2G_SECURITY password=$DUT_2G_PASSWORD bssid=$DUT_2G_BSSID" \
    --ssid                "ssid_idx=1 ssid=$DUT_5G_SSID security=$DUT_5G_SECURITY password=$DUT_5G_PASSWORD bssid=$DUT_5G_BSSID" \
    --ssid                "ssid_idx=2 ssid=$DUT_6G_SSID security=$DUT_6G_SECURITY password=$DUT_6G_PASSWORD bssid=$DUT_6G_BSSID" \
    --model_num           "$DUT_MODEL_NUM" \
    --hw_version          "$DUT_HW_VERSION" \
    --sw_version          "$DUT_SW_VERSION" \
    --dut_flag            "AP_MODE" \
    --dut_flag            "DHCPD-LAN"


# 3. CREATE/UPDATE AND BUILD CHAMBER VIEW SCENARIO
printf "> Build Chamber View Scenario with DUT \'$DUT_NAME\' and upstream \'$LF_UPSTREAM\'\n\n"

# Parse out resource and name for upstream port and WiFi radio
LF_UPSTREAM_RESOURCE=$(echo $LF_UPSTREAM | cut -d "." -f 2)
LF_UPSTREAM_NAME=$(echo $LF_UPSTREAM | cut -d "." -f 3)

LF_RADIO_RESOURCE=$(echo $LF_RADIO | cut -d "." -f 2)
LF_RADIO_NAME=$(echo $LF_RADIO | cut -d "." -f 3)

# TODO: Variable number of stations, variable band
python3 $LF_PY_SCRIPTS/create_chamberview.py \
    --lfmgr               $LF_MANAGER \
    --delete_scenario     \
    --create_scenario     $LF_SCENARIO_NAME \
    --raw_line            "profile_link 1.$LF_UPSTREAM_RESOURCE upstream 1 'DUT: $DUT_NAME LAN'     NA $LF_UPSTREAM_NAME,AUTO -1 NA" \
    --raw_line            "profile_link 1.$LF_RADIO_RESOURCE    STA-AUTO 1 'DUT: $DUT_NAME Radio-2' NA $LF_RADIO_NAME,AUTO"
