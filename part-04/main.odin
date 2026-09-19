package main

import rl "vendor:raylib"
import "core:math/linalg"

WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 640
SPEED :: 300
SCALE :: 4

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "window")
	defer rl.CloseWindow()

	devitt := rl.LoadTexture("assets/devitt.png")
	defer rl.UnloadTexture(devitt)

	pos := rl.Vector2{100, 100}
	dimensions := rl.Vector2{f32(devitt.width) * SCALE, f32(devitt.height) * SCALE}

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

		pos.x = clamp(pos.x, 0, WINDOW_WIDTH - dimensions.x)
		pos.y = clamp(pos.y, 0, WINDOW_HEIGHT - dimensions.y)

		rl.DrawTextureEx(devitt, pos, 0, SCALE, rl.WHITE)
		rl.EndDrawing()
	}
}
