package main

import rl "vendor:raylib"

WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 640

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "window")
	defer rl.CloseWindow()

	pos := rl.Vector2{100, 100}
	vel := rl.Vector2{100, 0}
	dimensions := rl.Vector2{80, 50}

	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		dt := rl.GetFrameTime()
		pos = pos + vel * dt
		rl.DrawRectangleV(pos, dimensions, rl.BLUE)
		rl.EndDrawing()
	}
}
