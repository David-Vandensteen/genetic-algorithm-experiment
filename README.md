# genetic-algorithm-experiment

Some draft code here for "playing" with genetic algorithm and heuristic method.

I'm writing **HAL** a multigame agent which try to finish some games on the **Nintendo NES** console ...  
Currently, he learn: **Space Harrier**, **Afterburner**, **Gradius**

The agent try, retry and evolve some solutions.  
He have a minimal information about the game (just a memory reading for the dead value)  
He put pad control over the [FCEUX](http://www.fceux.com) Lua library.  
(he does not "see" the game:  collision, enemies ...)



Training session video : [https://youtu.be/tQWdzBaPfcA](https://youtu.be/tQWdzBaPfcA)




You need [FCEUX](http://www.fceux.com) and the games roms.  
 - Launch [FCEUX](http://www.fceux.com) with the rom  
 - Load **hal.lua** script
 - You can pass the argument "**normal**" for a realtime speed emulator