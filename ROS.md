# ROS

### Run ros on any distro
[ROS-DOCKER](https://github.com/turlucode/ros-docker-gui)


### Basic commands

- `catkin_make` builds the project.
- `roscore` Start the root node.
- `rosrun <package> <program>` execute a node.
- `rospack list` list all installed packages.
- `rostopic list` list all the current active topics
- `rostopic info <topic>` print all the information about the topic(publishers / subscribers).
- `rostopic pub <topic> <mssg-typ> <mssg>` send a message to a topic.
- `rostopic echo <topic>` subscribe to a topic.
- `rostopic hz <topic>` get frequency of messages.
- `rosnode list` list all avaliable nodes.
- `rosnode info <node>` get detailed information about the node.
- `rosparam list` list all available parameters
- `rosmsg info <message> e.g. geometry_msgs/Twist` check the message structure.
- `rosbag record <topic> --duration=<X in seconds>` record some topic
- `rosbag play <topic_file>` replay the recorded topics  (very usefull for debugging)


## RQT
It is basically gui for command tools
-> `topic monitor` gui topics

### Compiled packages are not listed?
Re-source: `. ./devel/setup.zsh --extend`.
Check for successful source: `echo $ROS_PACKAGE_PATH`

### Launchfile


```xml
<launch>
  <node pkg="turtlesim" type="turtlesim_node" name="turtlesim_node" output="screen"/> # define node
  <node pkg="exercise2" type="pubvel" name="pubvel"  output="screen">
    <param name="scale_linear" value="1" type="double"/> # Parameters for our nodes (basically constants)
    <param name="scale_angular" value="4" type="double"/> # Use rosparam list to list them all
    <remap from="cmd_vel" to="/turtle1/cmd_vel" /> # Remap topic
  </node>
</launch>
```


### CmakeLists.txt


```bash
# Here you add addidional packages:
- rospy: to compile with python libraries
- roscpp: ROs c++ compiler
- geometry_msgs: Useful structs for position estimation 
find_package(catkin REQUIRED COMPONENTS rospy roscpp geometry_msgs)
```
