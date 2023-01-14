
# <p align="center">Minilibx Linux Installer</p>

This is a personnal project I made of bordome to easyli install the Minilibx on Linux.
Feel free to use it and to contribute to it, this is my first "real" script so it's probably not perfect.


## 🧐 Features
- Download and compile the minilibx from [here](https://github.com/42Paris/minilibx-linux)
- Install the compiled library in the /usr/local/lib folder to be able to use it in your projects with the -lmlx flag
- Install the minilibx header in the /usr/local/include folder to be able to use it in your projects with the #include <mlx.h> directive
- Install the man page in the /usr/local/man/man3 folder to access it everywhere with the man mlx command
- Come with a script to uninstall the library


## 🛠️ Usage instruction
```bash
sudo sh ./mlx_installer
sudo sh ./mlx_uninstaller
```

## 🙇 Author
#### Guillaume d'Harcourt
- Github: [@gd-harco](https://github.com/gd-harco)

