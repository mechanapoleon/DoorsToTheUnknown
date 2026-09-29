package main

import rl "vendor:raylib"
import "core:math/linalg"

NATIVE_WINDOW_WIDTH :: 105
NATIVE_WINDOW_HEIGHT :: 60
SCALE :: 10
WINDOW_WIDTH :: NATIVE_WINDOW_WIDTH * SCALE
WINDOW_HEIGHT :: NATIVE_WINDOW_HEIGHT * SCALE
SPEED :: 30 * SCALE

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "window")
	defer rl.CloseWindow()

	devittSprite := rl.LoadImage("assets/devitt.png")
	defer rl.UnloadImage(devittSprite)
	hall := rl.LoadTexture("assets/hall.png")
	defer rl.UnloadTexture(hall)
	devitt := rl.LoadTexture("assets/devitt.png")
	defer rl.UnloadTexture(devitt)

	devittCollisionBorder := rl.GetImageAlphaBorder(devittSprite, 0)

	pos := rl.Vector2{46, 24} * SCALE

	dimensions := rl.Vector2{devittCollisionBorder.width, devittCollisionBorder.height} * SCALE
	offset := rl.Vector2{devittCollisionBorder.x, devittCollisionBorder.y} * SCALE

	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.DrawTextureEx(hall, {0, 0}, 0, SCALE, rl.WHITE)
		dt := rl.GetFrameTime()
		direction := rl.Vector2{0, 0}

		if rl.IsKeyDown(.RIGHT) do direction += rl.Vector2{1, 0}
		if rl.IsKeyDown(.LEFT)  do direction += rl.Vector2{-1, 0}

		direction = linalg.normalize0(direction)
		vel := direction * SPEED
		pos = pos + vel * dt

		pos.x = clamp(pos.x, -offset.x, WINDOW_WIDTH - dimensions.x - offset.x)

		rl.DrawTextureEx(devitt, pos, 0, SCALE, rl.WHITE)
		rl.EndDrawing()
	}
}
