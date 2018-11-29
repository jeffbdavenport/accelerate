# Accelerate

An advanced free 3D game engine in development built on top of Vulkan, and GLFW. With the goal in mind of convention, speed, and high quality over configuration, as well as a means to serve as a solid alternative to production grade game engines.

Conventions and beliefs in mind thus far

- Engine is designed and tested for:
  - Vulkan, GLFW, sqlite3, Linux, X11, gdm3, Gnome-Shell-3, ext4
  
- Engine is not designed for:
  - MacOS, Windows, Direct3D, Direct X
  
  * However if it eventually works with anything, we're fine with that.
  
- Developers don't want to have to develop software to support multiple platforms such as MacOS, Windows, and Linux.
  - Linux is free and anyone can install it. If they care about the game enough, they will try Linux.
  - Most people using MacOS won't want to have to purchase Windows just to play the game, and most people on Windows won't want to have to pruchase a Mac just to play the game they want. But both of the two would consider installing Linux.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  accelerate:
    github: jeffreydvp/accelerate
```

## Usage

```crystal
require "accelerate"
```


## Development

See Contributing below

## Contributing

1. Fork it (<https://github.com/jeffreydvp/accelerate/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [jeffreydvp](https://github.com/jeffreydvp) Jeff Davenport - creator, maintainer
