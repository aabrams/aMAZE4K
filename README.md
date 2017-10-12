# aMAZE4K
3D FPS engine for the Atari 2600
; Originally by Adam Abrams
; License: MIT
;
;
; A 3D portal rendering game engine for the ATARI 2600 (VCS)

; 3D pane generation:
; Most of the screen is taken up by a playfield drawn from a network of zone descriptions.
; Zones are connected via portals (each zone having 0-n portals)
; Zone walls are described via a series of vertices (x,y) and some meta-data forming a convex polygon
; One panel half is drawn while the other is reflected by the VCS.
; The info for display of the pane is pre-computed and put into RAM in compressed format to be extracted
; during kernel display (see below). The format is designed to allow the kernel easy extraction and leave
; enough processing time free for sprites and some logic.
; The pane is 192 lines in height, double lines are used. Reflection mode is used to keep PF0 at the extreme left and right sides.
;
; 3D pipeline consists of the following:

; 1. Backface culling - Going over all vertices in the zone
; 2. Rotation - One vertex at a time
; 3. Translation - One vertex at a time
; 4. 2D Clipping - Based on current and previous vertex (clip against FOV line)
; 5. Projection - Either special-case at FOV edges, or simple 2D world -> 2D screen projection
;
; Zones are kept in ROM unrotated (first & last coordinate always on 0,0 - last is assumed, not in ROM)
; When player is in a zone or zone is viewable via portal its coordinates are rotated, translated, clipped & projected with the results stored in RAM
; Only visible walls are moved into RAM, backface culling done via comparison with NORMAL angles stored in ROM per zone wall
; 2D clipping in world coordinates is done as well before data is stored in RAM
; Rotation is done via sine, cosine tables as well as 8 by 8 bit signed multiply relying on a table
; Each zone has a displacement+rotation based on player or player+portal(s).
; It is assumed all zones are convex and amount of vertices (visible in zone+portal zones) must be kept 21 or less
; 3D pipeline is peformed only upon request of the game code (player turned, moved, etc.)
; ROM Zone Vertex -> Backface culling -> Rotate -> 2D World Clip -> Project

; * Polyfill Kernel
;
; The kernel is split into mini kerels, each specializing in specific task.
; The list of kernels and roles is below
; Once the trapeze is drawn it is reflected by the VCS, looking like a wall with correct perspective
; No overlap/gap is allowed, 3D pipeline must order polygons perfectly for kernels in stack

; RAM structure
;
; 63b	- Zone + Portal zones vertices (projection result with metadata)
; 9b	- More variables (Pointers, Player info, etc.)
; 24b	- Game data
; 32b	- Scratch RAM, used differently in different code areas
; ---
; 128b	- Total

; ROM structure (top down plan, not exact to the single byte level)
;
; Level data begin
; 128b	- 8 Sprites data
; 128b	- 8 Textures data
; 256b	- 64 portals data
; 1024b	- 256 vertices data (walls)
; 512b	- Texture Y Scale tables
; Level data end
; 96b	- Projection tables (inc. Fast ASLx4)
; 511b	- Mutiplication tables (8b by 8b with 8b product, signed)
; 16b	- Init
; 384b	- 3D engine (backface culling, rotation, translation, clipping, projection)
; 512b	- Game code (handle input and game logic)
; 384b	- Kernels (world & game displays)
; 48b	- ArcTan table
; 16b	- Sine table
; 64b	- Cosine table (overlap with Sine)
; 13b	- Padding
; ---
; 4096b	- Total
;
; *** Data Structures ***
;
; Portals List (key: ID, 6 bits)
;
; Bytes: Trans_X, Trans_Y, Meta, NextZone

; Vertices List (key: ID, 8 bits. Array ordered clockwise from 0,0 back to 0,0 - last assumed)
;
; Byte: Meta, Normal angle
; Byte: Vertex X,Y (-96..+95) - Special case is used for vertex [0,0], see below


; Polygon list for kernel draw
;
; Stack based and compressed starting at $FF, 3 bytes per entry (describes a polygon)
; M -	D7: 0 Portal Entry / 1 Wall
; 		D0-D2 - Texture 
;	 	D3-5 - Brightness 
; Y - Height of polygon on screen (0-15) 
; X - Normally describes screen X coordinate -96 to +95
;	- When new portal entered it signifies the texture/light location fraction in 4.4 fixed point unsigned (0 means start of polygon)

