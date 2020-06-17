#! /bin/bash

if [[ "x$1" = "x" ]]; then
    echo "Usage: build.sh videosort-version"
    echo "  (Resulting videosort-foo.pyz file will live in the dist directory)"
    exit 1
fi

mkdir -p dist
OUTPUT="dist/videosort-$1.pyz"

PVER=$(poetry --version)
if [[ $? -ne 0 ]]; then
    echo "poetry not found in PATH. Please install it via https://python-poetry.org/"
    exit 2
fi

SVER=$(shiv --version)
if [[ $? -ne 0 ]]; then
    echo "shiv not found in PATH. Please install it via 'pip install shiv'"
    exit 3
fi

export PIPENV_VERBOSITY=-1

shiv -o ${OUTPUT} \
    --site-packages=$(poetry run pipenv --venv)/lib/python3.7/site-packages \
    --python="/usr/bin/env python3.7" \
    --entry-point=VideoSort.__main__.main \
    --no-deps .

if [[ $? -ne 0 ]]; then
    echo "Sorry, something failed..."
    exit 4
fi

echo
echo "Created distribution script ${OUTPUT}"
