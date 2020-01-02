#!/bin/bash
#
# buildbot script for compiling android ROMs using drone CI

source ./config.sh

# Configure git
git config --global user.email "$GITHUB_EMAIL"
git config --global user.name "$GITHUB_USER"

export TELEGRAM_TOKEN=$(cat /tmp/tg_token)
export TELEGRAM_CHAT=$(cat /tmp/tg_chat)
export GITHUB_TOKEN=$(cat /tmp/gh_token)

# Delete useless darwin repos
trim_darwin() {
    cd .repo/manifests
	sed -i '/darwin/d' default.xml
    git commit -a -m "Magic"
    cd ../
	sed -i '/darwin/d' manifest.xml
    cd ../
}

cd /home/ci
git clone -q "https://$GITHUB_USER:${GITHUB_TOKEN}@github.com/$GITHUB_USER/google-git-cookies.git" &> /dev/null
if [ -e google-git-cookies ]; then
    bash google-git-cookies/setup_cookies.sh
    rm -rf google-git-cookies
else
    echo "google-git-cookies repo not found on your account, see steps on README"
fi

mkdir "$ROM"
cd "$ROM"

export outdir="out/target/product/$device"

# Initialize repo
repo init -u "$manifest_url" -b "$branch" --depth 1 &> /dev/null
trim_darwin &> /dev/null
echo "Sync started for $manifest_url

# Reset bash timer and begin syncing
SECONDS=0
if repo sync --force-sync --current-branch --no-tags --no-clone-bundle --optimized-fetch --prune -j16 -q &> /dev/null; then
	# Syncing completed, clone custom repos if any
	bash ./clone.sh

    echo "Build Started"
  
    Started: [See Progress]($ci_url)"
	
	# Reset bash timer and begin compilation
    SECONDS=0
    source build/envsetup.sh &> /dev/null
    if [ -e "device/$oem/$device" ]; then python3 ./dependency_cloner.py; fi
    lunch $rom_vendor_name_$device-userdebug &> /dev/null

    if mka bacon | grep $device; then
		# Build completed succesfully, upload it to github
		export finalzip_path=$(ls "$outdir/*2020*.zip" | tail -n -1)
		export zip_name=$(basename -s "$finalzip_path")
        echo "Build completed successfully in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s)"
        echo "Uploading"

        github-release "$release_repo" "$zip_name" "master" "$ROM for $device

Date: $(env TZ="$timezone" date)" "$finalzip_path"

        echo "Uploaded"
	
Download: {$zip_name}{https://github.com/$release_repo/releases/download/$zip_name/"$zip_name".zip}
echo "done"

