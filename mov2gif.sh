#!/usr/bin/env bash

usage() {
  echo
  echo "usage:  mov2gif.sh [-h] -i <in>.mov -o <out>.gif"
  echo
  echo "description:  convert 'mov' files into 'gif's."
  echo "options:"
  echo "   -h         print help"
  echo "   -i         input  .mov file"
  echo "   -o         output .gif file"
  echo
}

if ! command -v ffmpeg &> /dev/null; then
  echo "requirement: 'ffmpeg' could not be found"
  exit 1
fi

if ! command -v gifsicle &> /dev/null; then
  echo "requirement: 'gifsicle' could not be found"
  exit 1
fi

while [[ -n $1 ]]; do
  case $1 in
    -h|--help)
      usage
      exit 0
      ;;
    -i)
      shift
      in_mov="$1"
      shift
      ;;
    -o)
      shift
      out_gif="$1"
      shift
      ;;
    *)
      usage
      echo "unknown option: '$1'"
      exit 1
      ;;
  esac
done

if ! [[ -n ${in_mov} ]]; then
  usage
  echo "missing '-i <in>.mov' option"
  exit 1
fi

if ! [[ -n ${out_gif} ]]; then
  usage
  echo "missing '-o <out>.gif' option"
  exit 1
fi

ffmpeg -i ${in_mov} -pix_fmt rgb8 -r 10 ${out_gif} && gifsicle -O3 ${out_gif} -o ${out_gif}
