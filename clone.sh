#!/bin/bash
# clone repos for Cardinal - rolex

GITHUB='https://github.com/ghostrider-reborn'
BRANCH="lineage-15.1"

git clone -b $BRANCH $GITHUB/android-device-xiaomi-rolex device/xiaomi/rolex
git clone -b $BRANCH $GITHUB/android-vendor-xiaomi vendor/xiaomi/
git clone -j32 -b staging --depth=1 $GITHUB/android_kernel_xiaomi_msm8917-2 kernel/xiaomi/msm8917
