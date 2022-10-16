#!/bin/sh

if [ -n "$DESTDIR" ] ; then
    case $DESTDIR in
        /*) # ok
            ;;
        *)
            /bin/echo "DESTDIR argument must be absolute... "
            /bin/echo "otherwise python's distutils will bork things."
            exit 1
    esac
fi

echo_and_run() { echo "+ $@" ; "$@" ; }

echo_and_run cd "/home/arc/ros2_ws/src/catkin"

# ensure that Python install destination exists
echo_and_run mkdir -p "$DESTDIR/home/arc/ros2_ws/install/lib/python3/dist-packages"

# Note that PYTHONPATH is pulled from the environment to support installing
# into one location when some dependencies were installed in another
# location, #123.
echo_and_run /usr/bin/env \
    PYTHONPATH="/home/arc/ros2_ws/install/lib/python3/dist-packages:/home/arc/ros2_ws/build/catkin/lib/python3/dist-packages:$PYTHONPATH" \
    CATKIN_BINARY_DIR="/home/arc/ros2_ws/build/catkin" \
    "/usr/bin/python3" \
    "/home/arc/ros2_ws/src/catkin/setup.py" \
    egg_info --egg-base /home/arc/ros2_ws/build/catkin \
    build --build-base "/home/arc/ros2_ws/build/catkin" \
    install \
    --root="${DESTDIR-/}" \
    --install-layout=deb --prefix="/home/arc/ros2_ws/install" --install-scripts="/home/arc/ros2_ws/install/bin"
