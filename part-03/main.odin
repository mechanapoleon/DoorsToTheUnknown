package main

import rl "vendor:raylib"
import "core:math/linalg"

WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 640
SPEED :: 100

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "window")
	defer rl.CloseWindow()

	pos := rl.Vector2{100, 100}
	dimensions := rl.Vector2{80, 50}

	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		dt := rl.GetFrameTime()
		direction := rl.Vector2{0, 0}

		if rl.IsKeyDown(.RIGHT) do direction += rl.Vector2{1, 0}
		if rl.IsKeyDown(.LEFT)  do direction += rl.Vector2{-1, 0}
		if rl.IsKeyDown(.UP)    do direction += rl.Vector2{0, -1}
		if rl.IsKeyDown(.DOWN)  do direction += rl.Vector2{0, 1}

		direction = linalg.normalize0(direction)
		vel := direction * SPEED
		pos = pos + vel * dt
		rl.DrawRectangleV(pos, dimensions, rl.BLUE)
		rl.EndDrawing()
	}
}
