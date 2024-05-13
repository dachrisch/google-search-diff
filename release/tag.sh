#!/bin/zsh

# Fetch tag_name from pubspec.yaml
tag_name="v$(grep 'version:' ../pubspec.yaml | cut -d ' ' -f 2)"

# Check if tag_name is empty
if [ -z "$tag_name" ]; then
  echo "Cannot read tag from pubspec"
  echo "Usage: $0"
  exit 1
fi

echo "Tagging with $tag_name"

# Change to the parent directory
pushd ..

# Fetch all tags from remote to ensure the local tag list is up to date
git fetch --tags

# Check if the tag exists using exact matching
if git tag -l | grep -Fxq "$tag_name"; then
  echo "Removing existing tag $tag_name"
  git tag -d "$tag_name"
  git push --delete origin "$tag_name"
fi

# Add a new tag and push it to the remote repository
git tag -a "$tag_name" -m "Tagging version $tag_name"
git push origin "$tag_name"

# Return to the original directory
popd || exit
