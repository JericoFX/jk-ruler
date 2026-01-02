📏 JK Ruler
A simple, lightweight, and accurate 3D measuring tool for FiveM.

Ever needed to know the exact distance between two points while building a base? Or maybe you just want to check how long a road is? This tool uses the power of ox_lib to give you a clean, easy-to-use ruler right in your game world.

✨ Features
Precise Measurements: Uses ox_lib raycasting to snap exactly to surfaces or entities.
Smart 3D Text: The distance text changes size depending on how far away you are, so it's always readable and sits perfectly in the middle of the two points.
Two Modes:
Static Mode: Classic ruler. Set Point A, then set Point B. The line stays there.
Follow Mode: Set a starting Point A, and the ruler follows your player around, updating the distance in real-time as you walk away.
Built with Ox Lib: Fully integrated with lib.raycast, lib.addKey, and lib.notify for a smooth, performant experience.
📋 Requirements
ox_lib (Make sure this is running before you start JK Ruler).
🚀 Installation
Download the latest version of the script.
Extract the folder into your server's resources directory (e.g., resources/[standalone]/jk_ruler).
Add the following line to your server.cfg:
cfg

ensure jk_ruler
Start (or restart) your server.
🎮 Controls
Once in-game, you can use the following default keys:

Key
Action
F6	Toggle the Ruler On / Off.
F7	Switch between Static (2 points) and Follow mode.
E	Mark a Point (Set Point A, then Point B). In Follow mode, this sets the origin.

💡 How to Use
Press F6 to open the tool.
(Optional) Press F7 to choose if you want the line to follow you or stay fixed between two spots.
Aim at a location and press E to mark Point A.
Move to where you want the measurement to end and press E again to mark Point B (or just walk away if you are in Follow mode).
Done! You can see the distance floating right in the middle.
Press E again while measuring to reset the points, or F6 to close the tool completely.
⚙️ Configuration
If you want to change the default keys, simply open client/client.lua and look for the lib.addKey sections. You can change defaultKey to whatever keybind you prefer.

📝 Credits
Developed using ox_lib.