# ROS 2 


## Basic ROS 2 Commands

### 🔹 Workspace Setup

```bash
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
colcon build
source install/setup.bash
```

### 🔹 Package Management

```bash
ros2 pkg list               # List installed packages
ros2 pkg create <package>   # Create a new package
```

### 🔹 Nodes

```bash
ros2 node list                # List all running nodes
ros2 node info /node_name      # Get detailed info about a node
```

### 🔹 Topics

```bash
ros2 topic list                      # List all active topics
ros2 topic info /topic_name           # Get topic details (publishers, subscribers)
ros2 topic echo /topic_name           # View topic messages in real-time
ros2 topic pub /topic_name std_msgs/String "{data: 'hello'}" # Publish a message
ros2 topic hz /topic_name             # Measure message frequency
```

### 🔹 Services

```bash
ros2 service list                # List all available services
ros2 service type /service_name   # Show service type
ros2 service call /service_name std_srvs/srv/Empty {} # Call a service
```

### 🔹 Parameters

```bash
ros2 param list            # List all parameters
ros2 param get /node param # Get a parameter value
ros2 param set /node param value # Set a parameter value
```

### 🔹 Logging & Debugging

```bash
ros2 doctor                    # Diagnose ROS 2 environment
ros2 launch <package> <file>    # Launch a launch file
ros2 bag record /topic --duration <X>  # Record a topic
ros2 bag play <file>            # Replay recorded messages
```

---

## Launch Files

```xml
<launch>
  <node pkg="turtlesim" exec="turtlesim_node" name="turtle1" output="screen"/>
  <node pkg="demo_nodes_cpp" exec="talker" name="talker_node" output="screen"/>
</launch>
```

Run the launch file:

```bash
ros2 launch <package> <launch_file>
```

---

## CMakelists

```cmake
cmake_minimum_required(VERSION 3.5)
project(my_ros2_package)

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)

add_executable(talker src/talker.cpp)
ament_target_dependencies(talker rclcpp std_msgs)

install(TARGETS talker DESTINATION lib/${PROJECT_NAME})

ament_package()
```

---

## C++ Node

```cpp
#include "rclcpp/rclcpp.hpp"

class MinimalPublisher : public rclcpp::Node {
public:
    MinimalPublisher() : Node("minimal_publisher") {
        publisher_ = this->create_publisher<std_msgs::msg::String>("topic", 10);
        timer_ = this->create_wall_timer(
            500ms, std::bind(&MinimalPublisher::publish_message, this));
    }

private:
    void publish_message() {
        auto message = std_msgs::msg::String();
        message.data = "Hello, ROS 2!";
        publisher_->publish(message);
    }
    rclcpp::Publisher<std_msgs::msg::String>::SharedPtr publisher_;
    rclcpp::TimerBase::SharedPtr timer_;
};

int main(int argc, char *argv[]) {
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<MinimalPublisher>());
    rclcpp::shutdown();
    return 0;
}
```

Compile and run the node:

```bash
colcon build --packages-select my_ros2_package
ros2 run my_ros2_package talker
```

---

## Python Node

```python
import rclpy
from rclpy.node import Node
from std_msgs.msg import String

class MinimalPublisher(Node):
    def __init__(self):
        super().__init__('minimal_publisher')
        self.publisher_ = self.create_publisher(String, 'topic', 10)
        self.timer = self.create_timer(0.5, self.publish_message)

    def publish_message(self):
        msg = String()
        msg.data = 'Hello, ROS 2!'
        self.publisher_.publish(msg)

def main(args=None):
    rclpy.init(args=args)
    node = MinimalPublisher()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
```

Run the node:

```bash
ros2 run my_ros2_package minimal_publisher
```

---

## Writing a service

```cpp
#include "rclcpp/rclcpp.hpp"
#include "example_interfaces/srv/add_two_ints.hpp"

class AddTwoIntsService : public rclcpp::Node {
public:
    AddTwoIntsService() : Node("add_two_ints_service") {
        service_ = this->create_service<example_interfaces::srv::AddTwoInts>(
            "add_two_ints", std::bind(&AddTwoIntsService::handle_service, this, std::placeholders::_1, std::placeholders::_2));
    }

private:
    void handle_service(const std::shared_ptr<example_interfaces::srv::AddTwoInts::Request> request,
                        std::shared_ptr<example_interfaces::srv::AddTwoInts::Response> response) {
        response->sum = request->a + request->b;
        RCLCPP_INFO(this->get_logger(), "Returning sum: %ld", response->sum);
    }

    rclcpp::Service<example_interfaces::srv::AddTwoInts>::SharedPtr service_;
};

int main(int argc, char *argv[]) {
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<AddTwoIntsService>());
    rclcpp::shutdown();
    return 0;
}
```

Compile and run the service:

```bash
colcon build --packages-select my_ros2_package
ros2 run my_ros2_package add_two_ints_service
```

Test the service:

```bash
ros2 service call /add_two_ints example_interfaces/srv/AddTwoInts "{a: 2, b: 3}"
```

