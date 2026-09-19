package main

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(320, 180, "window")
	defer rl.CloseWindow()

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.EndDrawing()
	}
}
