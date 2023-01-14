#!/bin/sh

# This script is to uninstalled the mlx if it was installed with the mlx_installer.sh script.

EUID=$(bash -c 'echo $EUID')

# check if EUID is 0
if [ "$EUID" -ne 0 ]; then
	#echo red
	echo "\033[31m This script must be run as root \033[0m"
	exit 1
fi

# Remove the libmlx.a file
if ! rm -f /usr/local/lib/libmlx.a
then
	echo "Error: libmlx.a file not found in /usr/local/lib!"
	echo "Maybe it was not installed with the mlx_installer.sh script?"
	echo "ignoring..."
else
echo "libmlx.a removed successfully!"
fi

# Remove the mlx.h file
if ! rm -f /usr/local/include/mlx.h /usr/local/include/mlx_int.h
then
	echo "Error: mlx.h and mlx_int.h files not found in /usr/local/include!"
	echo "Maybe they were not installed with the mlx_installer.sh script?"
	echo "ignoring..."
else
	echo "Headers file removed successfully!"
fi
# Remove the man page
rm -f /usr/local/man/man3/mlx*.3
echo "Man page removed!"

# green text
echo "\033[32m Script ended \033[0m"
