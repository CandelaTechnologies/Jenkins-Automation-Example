#!/usr/bin/env bash

# Print commands as they're run
set -x
                                           

# 0. CHECK SCRIPT ARGUMENTS
if [[ $# -ne 1 ]]; then                                                               
    echo "! DUT configuration file argument not specified"                                                                                                                   
    echo "! usage: $0 DUTCFG"                                                         
    exit 1                                                                            
fi                                                                                    
                                                                                      
DUT_CFG_FILE=$1
if [[ ! -f $DUT_CFG_FILE ]]; then                                                     
    echo "! DUT configuration file '$DUT_CFG_FILE' does not exist"                    
    echo "! usage: $0 DUTCFG"        
    exit 1                                                                                                                                                                   
fi                                                                                                                                                                           
                                                                                      

# 1. LOAD DUT CONFIGURATION FILE                                                      
echo "> Loading DUT configuration from file \'$DUT_CFG_FILE\'"                                                                                                               
source $DUT_CFG_FILE


# 2. CREATE REPORT DIRECTORY
#
# Create report directory to store test results
mkdir -p $REPORT_DIR


# 3. RUN 'Dataplane' TEST
echo "Starting Dataplane test\n"

LF_SCRIPTS=lanforge-scripts
LF_PY_SCRIPTS=$LF_SCRIPTS/py-scripts

python3 $LF_PY_SCRIPTS/lf_dataplane_test.py \
    --mgr                 $LF_MANAGER \
    --dut                 $DUT_NAME \
    --upstream            $LF_UPSTREAM \
    --station             $LF_STATION \
    --duration            $TEST_LOOP_DURATION \
    --traffic_type        $TEST_TRAFFIC_TYPE \
    --traffic_direction   $TEST_TRAFFIC_DIRECTION \
    --download_speed      $TEST_TRAFFIC_CONFIGURED_THROUGHPUT \
    --opposite_speed      $TEST_TRAFFIC_CONFIGURED_OPPOSITE_THROUGHPUT \
    --pull_report         \
    --local_lf_report_dir $REPORT_DIR
