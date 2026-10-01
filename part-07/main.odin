package main

import rl "vendor:raylib"
import "core:math/linalg"

NATIVE_WINDOW_WIDTH :: 105
NATIVE_WINDOW_HEIGHT :: 60
SCALE :: 10
WINDOW_WIDTH :: NATIVE_WINDOW_WIDTH * SCALE
WINDOW_HEIGHT :: NATIVE_WINDOW_HEIGHT * SCALE
SPEED :: 30 * SCALE
FRAME_DURATION :: 0.1

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "window")
	defer rl.CloseWindow()

	devittSprite := rl.LoadImage("assets/devitt.png")
	defer rl.UnloadImage(devittSprite)
	devittWalkFrames : [8]rl.Texture2D
	devittWalkFrames = [8]rl.Texture2D{
		rl.LoadTexture("assets/devitt_walk_1.png"),
		rl.LoadTexture("assets/devitt_walk_2.png"),
		rl.LoadTexture("assets/devitt_walk_3.png"),
		rl.LoadTexture("assets/devitt_walk_4.png"),
		rl.LoadTexture("assets/devitt_walk_5.png"),
		rl.LoadTexture("assets/devitt_walk_6.png"),
		rl.LoadTexture("assets/devitt_walk_7.png"),
		rl.LoadTexture("assets/devitt_walk_8.png"),
	}

	defer rl.UnloadTexture(devittWalkFrames[0])
	defer rl.UnloadTexture(devittWalkFrames[1])
	defer rl.UnloadTexture(devittWalkFrames[2])
	defer rl.UnloadTexture(devittWalkFrames[3])
	defer rl.UnloadTexture(devittWalkFrames[4])
	defer rl.UnloadTexture(devittWalkFrames[5])
	defer rl.UnloadTexture(devittWalkFrames[6])
	defer rl.UnloadTexture(devittWalkFrames[7])

	animationFrame := 0
	animationFrameTimer : f32 = 0
	facingLeft : bool = false

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

		if direction.x == -1 do facingLeft = true
		if direction.x == 1 do facingLeft = false

		source := rl.Rectangle{0, 0, f32(devitt.width), f32(devitt.height)}
		if facingLeft do source.width = -source.width

		dest := rl.Rectangle{pos.x, pos.y, f32(devitt.width) * SCALE, f32(devitt.height) * SCALE}

		if direction.x == 0 {
			rl.DrawTexturePro(devitt, source, dest, {0, 0}, 0, rl.WHITE)
			animationFrame = 0
			animationFrameTimer = 0
		} else {
			animationFrameTimer += dt
			if animationFrameTimer >= FRAME_DURATION {
				animationFrameTimer = 0
				animationFrame += 1
				if animationFrame == 8 do animationFrame = 0
			}
			rl.DrawTexturePro(devittWalkFrames[animationFrame], source, dest, {0, 0}, 0, rl.WHITE)
		}
		rl.EndDrawing()
	}
}
