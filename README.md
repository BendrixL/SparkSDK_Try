# SparkSDK_Try
Particle Mobile SDK IOS App to read variables and run function on Core
This IOS app uses a Particle Core or Photon www.particle.io as the source of variable data and the target for 
functional action.  See CoreReadTLWriteLED program for embedded firmware.
You must edit this code to add your Particle Cloud username, password and the name of the Core/Photon you wish to
access.
The only two routines that can be combined as written are login and device id.  Combining other routines will cause
IOS crashes due to asynchronous operation of the SDK and lack of valid connections.  Also, combining variable 
read and function calls will resut in a race condition such that the variable data will not be the current data
from completion of the function call.
Used as written it all works very well and provides a good introduction to the Particle Mobile SDK.
