#!/bin/bash
# clone repos for Cardinal - rolex

GITHUB='https://github.com/ghostrider-reborn'
BRANCH="cardinal"

git clone -b $BRANCH $GITHUB/android_device_lenovo_A6020 device/lenovo/A6020
git clone -b $BRANCH $GITHUB/android_vendor_lenovo_A6020 vendor/lenovo/A6020
git clone -b $BRANCH $GITHUB/android_kernel_lenovo_msm8916 kernel/lenovo/msm8916
