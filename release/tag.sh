#!/bin/zsh

tag_name=$1

if [ -z $tag_name ];then
  echo "Usage: $0 <tag_name>"
  exit 1
fi
pushd ..
if git tag -l | grep $tag_name;then
  echo "removing existing tag $tag_name"
  git tag -d $tag_name
  git push --delete $tag_name
fi
git tag -a $tag_name
git push origin $tag_name

popd || exit
