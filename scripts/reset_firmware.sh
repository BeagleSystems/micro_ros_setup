#! /bin/bash

set -e
set -o nounset
set -o pipefail

if [ -z "$FW_TARGETDIR" ]; then
    FW_TARGETDIR=/home/beagle/Development/BeagleCompanion/firmware
else
    echo "Using firmware folder: $FW_TARGETDIR"
fi

PREFIX=$(ros2 pkg prefix micro_ros_setup)

# Checking if firmware exists
if [ -d $FW_TARGETDIR ]; then
    RTOS=$(head -n1 $FW_TARGETDIR/PLATFORM)
    PLATFORM=$(head -n2 $FW_TARGETDIR/PLATFORM | tail -n1)
else
    echo "Firmware folder not found. Please use ros2 run micro_ros_setup create_firmware_ws.sh to create a new project."
    exit 1
fi

# Reset specific firmware
if [ $PLATFORM != "generic" ] && [ -d "$PREFIX/config/$RTOS/generic" ]; then
    if [ -f $PREFIX/config/$RTOS/generic/reset.sh ]; then
      echo "Resetting firmware for $RTOS platform $PLATFORM"
      . $PREFIX/config/$RTOS/generic/reset.sh
    else
      echo "No reset step found for $RTOS platform $PLATFORM"
    fi
else
    if [ -f $PREFIX/config/$RTOS/$PLATFORM/reset.sh ]; then
      echo "Resetting firmware for $RTOS platform $PLATFORM"
      . $PREFIX/config/$RTOS/$PLATFORM/reset.sh
    else
      echo "No reset step found for $RTOS platform $PLATFORM"
    fi
fi
