#!/bin/bash

# Software License Agreement (BSD License)
#
# Authors : Brighten Lee <shlee@roas.co.kr>
#
# Copyright (c) 2020, ROAS Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
#   1. Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#
#   2. Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
# THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
# THE POSSIBILITY OF SUCH DAMAGE.

ROS_DISTRO="melodic" 

echo -e "\033[1;31mStarting PC setup ...\033[0m"
sudo apt update
sudo apt upgrade -y
sudo apt install -y ssh net-tools terminator chrony ntpdate vim git setserial
sudo ntpdate ntp.ubuntu.com

echo -e "\033[1;31mStarting ROS $ROS_DISTRO installation ...\033[0m"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt install -y ros-$ROS_DISTRO-desktop-full

echo -e "\nsource /opt/ros/$ROS_DISTRO/setup.bash\nsource ~/catkin_ws/devel/setup.bash\n\nexport ROS_MASTER_URI=http://localhost:11311" >> ~/.bashrc
source /opt/ros/$ROS_DISTRO/setup.bash

sudo apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential python-rosdep ros-$ROS_DISTRO-rqt* ros-$ROS_DISTRO-ros-control ros-$ROS_DISTRO-ros-controllers ros-$ROS_DISTRO-navigation
sudo rosdep init
rosdep update

if [ ! -d "$HOME/catkin_ws" ]; then
  echo -e "\033[1;31mCreating ROS workspace ...\033[0m"
  mkdir -p ~/catkin_ws/src
  cd ~/catkin_ws/src
  catkin_init_workspace
  cd ~/catkin_ws
  catkin_make
fi

echo -e "\033[1;31mStarting RealSense SDK installation ...\033[0m"
sudo apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" -u
sudo apt install -y librealsense2-dkms librealsense2-utils
sudo apt install -y ros-$ROS_DISTRO-realsense2-camera