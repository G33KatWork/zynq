DESCRIPTION = "A quadrocopter image"

IMAGE_FEATURES += "package-management ssh-server-dropbear tools-sdk tools-debug debug-tweaks dev-pkgs"

CORE_IMAGE_EXTRA_INSTALL += "\
	kernel-dev \
	"

#CORE_IMAGE_EXTRA_INSTALL += "roslaunch"
#CORE_IMAGE_EXTRA_INSTALL += "roswtf roscpp rospy roscreate rosunit roslib rosbash rosbuild roslang rosmake rosclean rospack roscpp-traits rostime"
#CORE_IMAGE_EXTRA_INSTALL += "roscpp-serialization rosmsg rosout rostopic rospy rosbag rosgraph rosmaster rosconsole roslaunch rosnode rosparam rosgraph-msgs"
#CORE_IMAGE_EXTRA_INSTALL += "rostest roscpp rosservice roswtf class-loader actionlib nodelet catkin python-rosdep python-rospkg python-catkin-pkg python-rosinstall"
#CORE_IMAGE_EXTRA_INSTALL += "catkin message-runtime python-wstool "
#CORE_IMAGE_EXTRA_INSTALL += "rosserial-python rosserial-arduino rosserial-client"
##CORE_IMAGE_EXTRA_INSTALL += "freenect-launch"

CORE_IMAGE_EXTRA_INSTALL += "screen"
CORE_IMAGE_EXTRA_INSTALL += "libstdc++-dev"
CORE_IMAGE_EXTRA_INSTALL += "libc6-dev"
CORE_IMAGE_EXTRA_INSTALL += "vim git"
CORE_IMAGE_EXTRA_INSTALL += "i2c-tools"
CORE_IMAGE_EXTRA_INSTALL += "v4l-utils media-ctl yavta"
CORE_IMAGE_EXTRA_INSTALL += "opencv python3-opencv"

inherit core-image
