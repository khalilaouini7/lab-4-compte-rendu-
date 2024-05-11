#import "Class.typ": *


#show: ieee.with(
  title: [#text(smallcaps("Lab #4: ROS2 using RCLPY in Julia"))],
  /*
  abstract: [
    #lorem(10).
  ],
  */
  authors:
  (
    (
      name: "Abdelbacet Mhamdi",
      department: [Senior-lecturer, Dept. of EE],
      organization: [ISET Bizerte --- Tunisia],
      profile: "a-mhamdi",
    ),

    
    (
      name: "Aouini Khalil",
      department: [Dept. of EE],
      organization: [ISET Bizerte --- Tunisia],
      profile: "khalilaouini7",
    ),
    /*
    (
      name: "Student 2",
      department: [Dept. of EE],
      organization: [ISET Bizerte --- Tunisia],
      profile: "abc",
    ),
    (
      name: "Student 3",
      department: [Dept. of EE],
      organization: [ISET Bizerte --- Tunisia],
      profile: "abc",
    )
  */

  )
  // index-terms: (""),
  // bibliography-file: "Biblio.bib",
)
- In this lab you gonna find two part the first part is a execution of the programme and the second part is an explination of code lines 
  
- You are required to carry out this lab using the REPL as in @fig:repl. 

#figure(
	image("Images/REPL.png", width: 100%, fit: "contain"),
	caption: "Julia REPL"
	) <fig:repl>
  = First part : 
  in this part we execute the publisher/subscriber prograame and show you the result .  so we gonna use ROS2 and julia to give them name first to and link them to a topic by using this two programme after we install ros2 

We begin first of all by sourcing our ROS2 installation as follows:
```zsh
source /opt/ros/humble/setup.zsh
```

#let publisher=read("../Codes/ros2/publisher.jl")
#let subscriber=read("../Codes/ros2/subscriber.jl")

#raw(publisher, lang: "julia")
#raw(subscriber, lang: "julia")
 In a newly opened terminal, we need to start the publisher programme how start broadcasted a message first . second execute subscriber programme that listens to the messages being by our previous publisher 
 - * the result of the execution :*
#figure(
	image("Images/pub-sub.png", width: 100%),
	caption: "Minimal publisher/subscriber in ROS2",
) <fig:pub-sub>

= Second part :
in this part we gonna explain the first programme function and the result showing up 

*- first step :*

first of all we gonna lunch and initialition the subscriber / publisher programme :
- the publisher :
```julia
using PyCall
# Import the rclpy module from ROS2 Python
rclpy = pyimport("rclpy")
str = pyimport("std_msgs.msg")

# Initialize ROS2 runtime 
rclpy.init()
 ```
 - the subscriber :
 ```julia 
using PyCall

rclpy = pyimport("rclpy")
str = pyimport("std_msgs.msg")

# Initialization
rclpy.init()
```
*- second step *

in this step we will create a node contain the two parts names 
- publisher :
```julia 
# Create node
node = rclpy.create_node("my_publisher")
rclpy.spin_once(node, timeout_sec=1)
```
- subscriber :
```julia 
# Create node
node = rclpy.create_node("my_subscriber")
```
*- thrid step :*

in this step we gonna link up two node to the topic infodev like in fig 3

#figure(
	image("Images/rqt_graph.png", width: 100%),
	caption: "rqt_graph",
) <fig:rqt_graph>
- the publisher :
```julia
# Create a publisher, specify the message type and the topic name
pub = node.create_publisher(str.String,"infodev", 10)
 ```
 - the subscriber :
```julia 
# Create a ROS2 subscription
sub = node.create_subscription(str.String, "infodev", callback, 10)
```
*- fourth step :*
in this step we gonna choose the message and how many time it will broadcasted
```julia
# Publish the message `txt`
for i in range(1, 100)
    msg = str.String(data="Hello, ROS2 from Julia! ($(string(i)))")
    pub.publish(msg)
    txt = "[TALKER] " * msg.data 
    @info txt
    sleep(1)
end
```
```julia 
# Callback function to process received messages
function callback(msg)
    txt = "[LISTENER] I heard: " * msg.data
    @info txt
end
```
*-last step :*
we onna close up the programme and end the brodcast
```julia
# Cleanup
rclpy.shutdown()
node.destroy_node()
 ```
```julia 
# Cleanup
node.destroy_node()
rclpy.shutdown()
```