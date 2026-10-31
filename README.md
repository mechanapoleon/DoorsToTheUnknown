# Doors to the Unknown — code

Companion code for [Doors to the Unknown](https://doorstotheunknown.substack.com),
a blog series (in Italian) on building a video game from scratch with
[Odin](https://odin-lang.org) and [raylib](https://www.raylib.com).

Each `part-NN` folder contains the final code at the end of the corresponding post,
so you can download it and run it while following along.

## Requirements

The [Odin compiler](https://odin-lang.org/docs/install/). raylib comes bundled with Odin
as `vendor:raylib`, so nothing else has to be installed, apart from the graphics
libraries your operating system already needs for OpenGL.

## Running

Run the code from inside the folder of the part you want, because asset paths are relative:

```sh
cd part-04
odin run .
```

## Parts

| Part | Post | What the code does |
|------|------|--------------------|
| [00](part-00) | [Part 0](https://doorstotheunknown.substack.com/p/costruire-videogiochi-da-zero-0) | Hello world in Odin |
| [01](part-01) | [Part 1](https://doorstotheunknown.substack.com/p/costruire-videogiochi-da-zero-1) | Opening a window with raylib |
| [02](part-02) | [Part 2](https://doorstotheunknown.substack.com/p/costruire-videogiochi-da-zero-2) | A rectangle moving at constant speed |
| [03](part-03) | [Part 3](https://doorstotheunknown.substack.com/p/costruire-videogiochi-da-zero-3) | Keyboard movement and normalized direction |
| [04](part-04) | [Part 4](https://doorstotheunknown.substack.com/p/costruire-videogiochi-da-zero-4) | Window borders with `clamp`, loading and scaling a texture |
| [05](part-05) | [Part 5](https://doorstotheunknown.substack.com/p/costruire-videogiochi-da-zero-3-6af) | Collision rectangle from the sprite's alpha border (`GetImageAlphaBorder`), `clamp` with an offset |
| [06](part-06) | [Part 6](https://doorstotheunknown.substack.com/p/costruire-videogiochi-da-zero-5) | Room background, native resolution scaled by an integer factor, horizontal-only movement |
| [07](part-07) | [Part 7](https://doorstotheunknown.substack.com/p/costruire-videogiochi-da-zero-7) | Walking animation from 8 frames, idle frame when still, sprite mirrored when facing left |
| [08](part-08) | [Part 8](https://doorstotheunknown.substack.com/p/costruire-videogiochi-da-zero-8) | An NPC defined with a struct, interaction area checked with `CheckCollisionRecs`, tint highlight and timed dialogue with `DrawText` |
| [09](part-09) | [Part 9](https://doorstotheunknown.substack.com/p/costruire-videogiochi-da-zero-9) | A first function that turns an image to grayscale pixel by pixel (`LoadImageColors`), background switched between color and grayscale with the space bar |

## Acknowledgments

This series is heavily inspired by the work of [Karl Zylinski](https://zylinski.se/),
in particular his tutorials
[Make games using Odin and Raylib](https://zylinski.se/posts/gamedev-for-beginners-using-odin-and-raylib-1/)
and his book [Understanding the Odin Programming Language](https://odinbook.com/).
Thank you!

Giovanni is porting the series to [C](https://github.com/Giomamo/Costruire-videogiochi-da-zero),
and Marco to [Zig](https://github.com/marco-secci/zig-engine).

The graphics used from part 4 onwards come from *The Last Door* by
[The Game Kitchen](https://thegamekitchen.com/), see [ASSETS.md](ASSETS.md).

## License

The code is released under the [MIT License](LICENSE).
Assets are covered by their own licenses, see [ASSETS.md](ASSETS.md).
