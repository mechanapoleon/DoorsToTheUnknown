package main

import rl "vendor:raylib"
import "core:math/linalg"


/* ------------------ CONSTANTS -------------- */

NATIVE_WINDOW_WIDTH :: 105
NATIVE_WINDOW_HEIGHT :: 60
SCALE :: 10
WINDOW_WIDTH :: NATIVE_WINDOW_WIDTH * SCALE
WINDOW_HEIGHT :: NATIVE_WINDOW_HEIGHT * SCALE
SPEED :: 30 * SCALE
FRAME_DURATION :: 0.1


/* --------------- DATA STRUCTURE ------------ */

Npc :: struct {
	name: string,
	texture: rl.Texture2D,
	pos: rl.Vector2,
	area: rl.Rectangle,
}


/* ---------------- FUNCTIONS ------------------ */
makeGrayScaleTexture :: proc(image: rl.Image) -> rl.Texture2D {
	colors := rl.LoadImageColors(image)
	defer rl.UnloadImageColors(colors)

	for i in 0..< image.width * image.height {
		c := colors[i]
		gray := u8((int(c.r) + int(c.g) + int(c.b)) / 3)
		colors[i] = rl.Color{gray, gray, gray, c.a}
	}

	grayImage := rl.Image{
		data = colors,
		width = image.width,
		height = image.height,
		mipmaps = 1,
		format = .UNCOMPRESSED_R8G8B8A8,
	}
	return rl.LoadTextureFromImage(grayImage)
}


/* ----------------- MAIN ------------ */
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
	isTalking : bool = false
	talkTimer : f32 = 0

	hallImage := rl.LoadImage("assets/hall.png")
	defer rl.UnloadImage(hallImage)
	hall := rl.LoadTextureFromImage(hallImage)
	defer rl.UnloadTexture(hall)
	hallGray := makeGrayScaleTexture(hallImage)
	defer rl.UnloadTexture(hallGray)
	isGray : bool = false
	anthony := Npc {
		name = "Anthony",
		texture = rl.LoadTexture("assets/anthony.png"),
		pos = rl.Vector2{62 * SCALE, 24 * SCALE},
		area = rl.Rectangle{63 * SCALE, 30 * SCALE, 17 * SCALE, 21 * SCALE},
	}
	defer rl.UnloadTexture(anthony.texture)
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
		if rl.IsKeyPressed(.SPACE) do isGray = !isGray

		if isGray {
			rl.DrawTextureEx(hallGray, {0, 0}, 0, SCALE, rl.WHITE)
		} else {
			rl.DrawTextureEx(hall, {0, 0}, 0, SCALE, rl.WHITE)
		}
		dt := rl.GetFrameTime()
		direction := rl.Vector2{0, 0}

		if !isTalking {
			if rl.IsKeyDown(.RIGHT) do direction += rl.Vector2{1, 0}
			if rl.IsKeyDown(.LEFT)  do direction += rl.Vector2{-1, 0}
		}

		direction = linalg.normalize0(direction)
		vel := direction * SPEED
		pos = pos + vel * dt

		pos.x = clamp(pos.x, -offset.x, WINDOW_WIDTH - dimensions.x - offset.x)

		devittCollision := rl.Rectangle{pos.x + offset.x, pos.y + offset.y, dimensions.x, dimensions.y}
		canInteract := rl.CheckCollisionRecs(devittCollision, anthony.area)

		if direction.x == -1 do facingLeft = true
		if direction.x == 1 do facingLeft = false

		source := rl.Rectangle{0, 0, f32(devitt.width), f32(devitt.height)}
		if facingLeft do source.width = -source.width

		dest := rl.Rectangle{pos.x, pos.y, f32(devitt.width) * SCALE, f32(devitt.height) * SCALE}

		if canInteract {
			rl.DrawTextureEx(anthony.texture, anthony.pos, 0, SCALE, rl.YELLOW)
		} else {
			rl.DrawTextureEx(anthony.texture, anthony.pos, 0, SCALE, rl.WHITE)
		}

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

		if isTalking {
			textX := i32(anthony.pos.x)
			textY := i32(anthony.pos.y) + 3 * SCALE
			talkTimer += dt
			if talkTimer < 1.5 {
				rl.DrawText("Hello, I'm Anthony.", textX, textY, 20, rl.WHITE)
			} else if talkTimer < 3 {
				rl.DrawText("Nice to meet you.", textX, textY, 20, rl.WHITE)
			} else {
				isTalking = false
				talkTimer = 0
			}
		} else if canInteract && rl.IsKeyPressed(.E) {
			isTalking = true
		}

		rl.EndDrawing()
	}
}
