# ROS


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
