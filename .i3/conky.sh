#!/bin/sh
# Send header so that i3 knows we are using JSON
echo '{"version":1}'
echo '['
echo '[],'
exec conky -c $HOME/.i3/conkyrc
