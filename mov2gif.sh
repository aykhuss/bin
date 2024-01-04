#!/usr/bin/env bash

usage() {
  echo
  echo "usage:  mov2gif.sh [-h] -i <IN>.mov [-o <OUT>.gif] [--fps <INT>]"
  echo
  echo "description:  convert 'mov' files into 'gif's."
  echo "options:"
  echo "   -h         print help"
  echo "   -i         input  <IN>.mov  file"
  echo "   -o         output <OUT>.gif file (default: '<IN>.gif')"
  echo "   --fps      frames per second in conversion"
  echo
}

#> check needed commands are available on the system
if ! command -v ffmpeg &> /dev/null; then
  echo "requirement: 'ffmpeg' could not be found"
  exit 1
fi
if ! command -v gifsicle &> /dev/null; then
  echo "requirement: 'gifsicle' could not be found"
  exit 1
fi

#> defaults
fps=10

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
    --fps)
      shift
      fps="$1"
      shift
      ;;
    *)
      usage
      echo "unknown option: '$1'"
      exit 1
      ;;
  esac
done

#> checks
if ! [[ -n ${in_mov} ]]; then
  usage
  echo "missing '-i <in>.mov' option"
  exit 1
fi
if ! [[ ${fps} =~ ^[0-9]+$ ]]; then
  usage
  echo "fps must be an integer: ${fps}"
  exit 1
fi

#> no outputgiven:  derive from input file
if ! [[ -n ${out_gif} ]]; then
  out_gif=${in_mov%.*}.gif
fi

ffmpeg -i ${in_mov} -pix_fmt rgb8 -r ${fps} ${out_gif} && gifsicle -O3 ${out_gif} -o ${out_gif}
