# Connect to uart
- `sudo dmesg | grep tty` - find uart device 
- `sudo minicom -D /dev/ttyACM0 -b 115200` - connect to uart device

ECHO TO UART DEVICE `ctrl + a e`

(https://blog.mbedded.ninja/programming/operating-systems/linux/linux-serial-ports-using-c-cpp/)[programiranje uarta]

LEAVE MINICOM (this is the hard one;;)   ctrl + a and then x
