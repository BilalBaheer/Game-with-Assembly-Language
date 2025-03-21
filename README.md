Pac-Man Game in Assembly

This is a simple Pac-Man-like game written in assembly for a custom processor or MINI_OS simulator. It uses interrupt-driven controls and a memory-mapped display for rendering graphics.

Overview
Captures player input via the keyboard using an interrupt-driven approach.
Controls a character ('>') that moves up, down, left, and right using the arrow keys.
Uses memory-mapped I/O to render characters directly on a screen buffer.
Handles keyboard events through an interrupt service routine (ISR).
Implements a timer mechanism to regulate gameplay speed.
Features
✅ Real-time Movement: Character moves in response to arrow key inputs.
✅ Memory-Mapped Display: Characters are drawn directly to a video buffer.
✅ Interrupt-Driven Input Handling: Efficient keyboard event processing.
✅ Basic Game Logic: Maintains player position and enforces screen boundaries.
✅ Adjustable Timer: Controls the speed of gameplay updates.

How It Works
Initialization:

Sets up interrupt vectors to capture keyboard input.
Initializes the display buffer and draws the game environment.
Main Loop:

Continuously waits for input and updates the screen.
Keyboard Interrupt Handler (KEYISR):

Detects arrow key presses and moves the player accordingly.
Allows quitting the game with the 'x' key.
Rendering System (putChar & show50Man):

Displays characters at specific X, Y positions on the screen.
Erases the previous position before updating the new one.
Timer System:

Ensures movement updates occur at a controlled pace.
Controls
Arrow Keys → Move the character (>, <, ^, v).
'X' Key → Quit the game.
