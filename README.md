# AOSP_Docker_Build
This is a Dockerfile for the build environment of AOSP and Android-x86. 
You can directly pull the docker image from docker hub via the [image here](https://hub.docker.com/repository/docker/yoda117/aosp_build/). 
The Dockerfile is a modified version from [AOSP Docker](https://android.googlesource.com/platform/build/+/master/tools/docker) with a more up-to-date OS version and dependencies,
  as well as adaptations for Android-x86 building.
  
You can build the Dockerfile exactly the same as AOSP Docker using the following commands:
```
docker build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t aosp_build .
```
To run the docker, use
```
docker run -it --rm -v $ANDROID_BUILD_TOP:/src --net host --privileged -v /dev/bus/usb:/dev/bus/usb aosp_build
```
where `$ANDROID_BUILD_TOP` is the root directory of your AOSP/Android-x86 sources.

Then you can
```
cd /src
source build/envsetup.sh
lunch
```
to configure and build the AOSP/Android-x86 sources. The USB device mapping also allows you to use adb and fastboot to flash your mobile devices.

## Android source download
Android sources are managed via the `repo` too, which is already included in the docker. 

Alternatively, follow the instructions in https://gerrit.googlesource.com/git-repo/+/HEAD/README.md to install it.

To download Android-x86 sources,
```bash
mkdir android
cd android
# Change nougat-x86 (Android 7.1) to other branches (see the branch names in https://www.android-x86.org/source.html) if you want
repo init -u https://git.code.sf.net/p/android-x86/manifest -b nougat-x86
repo sync --no-tags --no-clone-bundle
```

To download AOSP sources,
```bash
mkdir android
cd android
# Change android-15.0.0_r3 to other branches (see the branch names in https://source.android.com/docs/setup/reference/build-numbers#source-code-tags-and-builds) if you want
repo init -u https://android.googlesource.com/platform/manifest -b android-15.0.0_r3
repo sync --no-tags --no-clone-bundle
```
