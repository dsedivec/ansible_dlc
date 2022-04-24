#!/usr/bin/env bash

set -euo pipefail

tag_msg=""

while [ $# -gt 0 ]; do
	case "$1" in
		-m)
			if [ $# -lt 2 ]; then
				echo "-m needs message argument" >&2
				exit 1
			fi
			tag_msg=$2
			shift 2
			;;

		*)
			echo "$(basename "$0") [-m <tag msg>]"
			if [ "$1" = "-h" ]; then
				exit 0
			else
				exit 1
			fi
			;;
	esac
done

cd "$(dirname "$0")"
version=$(awk '/^version:/{print $2;exit(0)}' galaxy.yml)
if [ -z "$version" ]; then
	echo "Can't read version from galaxy.yml" >&2
	exit 1
fi
version_tag=v${version}
if git rev-parse -q --verify "${version_tag}^{tag}" >/dev/null; then
	echo "${version_tag} tag already exists" >&2
	exit 1
fi
tarball=dsedivec-ansible_dlc-${version}.tar.gz
tag_args=()
if [ -n "$tag_msg" ]; then
	tag_args+=(-m "$tag_msg")
fi

set -x
rm -f "$tarball"
ansible-galaxy collection build
ansible-galaxy collection publish "$tarball"
git tag -a "v$version" "${tag_args[@]}"
git push --tags origin
