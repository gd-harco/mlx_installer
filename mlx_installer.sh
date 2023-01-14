#!/bin/sh

# This script is aiming to installe the minilibx on a linux machine, including the mlx.h header file and the man page.

# Function to print in color the text passed as argument
# Usage: print_color <color> <text>
print_color()
{
	case "$1" in
		red)
			printf "\033[0;31m"
			;;
		green)
			printf "\033[0;32m"
			;;
		yellow)
			printf "\033[0;33m"
			;;
		blue)
			printf "\033[0;34m"
			;;
		magenta)
			printf "\033[0;35m"
			;;
		cyan)
			printf "\033[0;36m"
			;;
		*)
			printf "\033[0m"
			;;
	esac
	printf  "%s\n" "$2"
	printf "\033[0m"
}

clean()
{
	if [ "$1" = "dir" ]
	then
		value=1
	fi
	if [ "$1" = "lib" ]
	then
		value=2
	fi
	if [ "$1" = "includes" ]
	then
		value=3
	fi
	if [ "$1" = "all" ]
	then
		value=4
	fi
	if [ "$value" -ge 1 ]
	then
		print_color blue "Cleaning the temp directory..."
		rm -rf "$temp_dir"
		print_color green "Temp directory cleaned successfully!"
	fi
	if [ "$value" -ge 2 ]
	then
		print_color blue "Removing libmlx.a from /usr/local/lib..."
		rm -rf /usr/local/lib/libmlx.a
		print_color green "Libmlx.a removed successfully!"
	fi
	if [ "$value" -ge 3 ]
	then
		print_color blue "Removing includes files from usr/local/include..."
		rm -rf /usr/local/include/mlx.h
		rm -rf /usr/local/include/mlx_int.h
		print_color green "Includes files removed successfully!"
	fi
	if [ "$value" -ge 4 ]
	then
		print_color blue "Removing the man page..."
		rm -rf /usr/local/man/man3/mlx*.1
		print_color "Man page removed successfully!"
	fi
}

# Run echo $EUID and put it in a variable
# If the variable is 0, then the script is run as root
# If the variable is not 0, then the script is not run as root

EUID=$(bash -c 'echo $EUID')

# check if EUID is 0
if [ "$EUID" -ne 0 ]; then
	print_color red "This script must be run as root"
	print_color red "Try running it with sudo"
	exit 1
fi

# Dir variables
temp_dir=$(mktemp -d -t mlx_installer-XXXXXX)

# Chek if git is installed
check_git=$(which git)
if [ "$check_git" = "git not found" ];
then
	print_color yellow "Git not found, installing git..."
	apt-get install -y git
fi

# Downloading the minilibx
print_color blue "Downloading the minilibx..."
if ! git clone https://github.com/42Paris/minilibx-linux.git "$temp_dir"
then
	print_color red "Failed to download the minilibx"
	exit 1
fi

# Installing the required dependencies
print_color blue "Installing the required dependencies..."
if ! apt-get install -y gcc make xorg libxext-dev libbsd-dev
then
	print_color red "Failed to install the required dependencies"
	clean dir
	exit 1
fi
print_color green "Required dependencies installed successfully!"

# Compiling the minilibx, stop if the compilation failed
print_color blue "Compiling the minilibx..."
if ! make -C "$temp_dir"
then
	print_color red "Failed to compile the minilibx"
	clean dir
	exit 1
fi
print_color green "Minilibx compiled successfully!"
cd "$temp_dir" || exit
# Copying the minilibx to the /usr/local/lib directory, stop if the copy failed
print_color blue "Copying the minilibx to the /usr/local/include directory..."
if ! cp libmlx.a /usr/local/lib
then
	print_color red "Failed to copy the minilibx to the /usr/local/lib directory"
	clean dir
	exit 1
fi
print_color green "libmlx.a copied successfully!"

# Copying the mlx.h header file to the /usr/local/include directory, stop if the copy failed
echo "Copying the mlx.h header file to the /usr/local/include directory..."
if ! cp mlx.h /usr/local/include
then
	print_color red "Failed to copy the mlx.h header file to the /usr/local/include directory"
	clean lib
	exit 1
fi
if ! cp mlx_int.h /usr/local/include
then
	print_color red "Failed to copy the mlx_int.h header file to the /usr/local/include directory"
	clean includes
	exit 1
fi
print_color green "Header files copied successfully!"

# Installing the man page
print_color blue "Installing mlx man page..."
mkdir -p /usr/local/man/man3
if ! cp man/man3/mlx*.3 /usr/local/man/man3
then
	print_color red "Failed to install the man page"
	clean all
	exit 1
fi
print_color green "Man page installed successfully!"

print_color green "Minilibx installed successfully!
You can now use the minilibx in your projects using the \#include <mlx.h> directive.
Dont forget to link the libmlx.a library when compiling your project using the -lmlx -lXext -lX11 -lm -lbsd flags."

# Cleaning the temp directory
clean dir
exit 0
