#!/bin/bash

# Function to create a feature branch
create_feature_branch() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: $0 feature <branch-name>"
    exit 1
  fi

  BRANCH_NAME=$1
  git checkout development
  git pull origin development
  git checkout -b "feature/$BRANCH_NAME"
  echo "Successfully created and checked out to feature branch: feature/$BRANCH_NAME"
}

# Function to handle commits with prefixes
create_commit() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: $0 commit [--skip-add] <prefix> <commit-message>"
    exit 1
  fi

  SKIP_ADD=false
  PREFIX=""
  COMMIT_MESSAGE=""

  # Parse options
  if [ "$1" == "--skip-add" ]; then
    SKIP_ADD=true
    PREFIX=$2
    COMMIT_MESSAGE=$3
  else
    PREFIX=$1
    COMMIT_MESSAGE=$2
  fi

  # Convert commit message to lowercase
  COMMIT_MESSAGE=$(echo "$COMMIT_MESSAGE" | tr '[:upper:]' '[:lower:]')

  # Define prefix mapping
  case "$PREFIX" in
    feat|feature)
      PREFIX="feat"
      ;;
    fix)
      PREFIX="fix"
      ;;
    refactor)
      PREFIX="refactor"
      ;;
    perf)
      PREFIX="perf"
      ;;
    test)
      PREFIX="test"
      ;;
    chore)
      PREFIX="chore"
      ;;
    docs)
      PREFIX="docs"
      ;;
    style)
      PREFIX="style"
      ;;
    *)
      echo "Unknown prefix: $PREFIX"
      echo "Supported prefixes: feat, fix, refactor, perf, test, chore, docs, style"
      exit 1
      ;;
  esac

  # Check for staged changes or add all if needed
  if [ "$SKIP_ADD" = false ]; then
    git add .
  fi

  if git diff --cached --quiet; then
    echo "No changes staged for commit."
    exit 1
  fi

  # Construct the commit message with prefix
  FULL_COMMIT_MESSAGE="$PREFIX: $COMMIT_MESSAGE"

  # Commit the changes with the message
  git commit -m "$FULL_COMMIT_MESSAGE"
  echo "Committed with message: $FULL_COMMIT_MESSAGE"
}

# Function to get the latest tag based on the platform
get_latest_tag() {
  local platform=$1
  local suffix=$2

  if [ -z "$platform" ] || [ -z "$suffix" ]; then
    echo "Platform and suffix must be specified."
    exit 1
  fi

  git tag | grep "$suffix" | sort -V | tail -n 1
}

# Function to increment the version
increment_version() {
  local current_version=$1
  local version_parts=(${current_version//-/ })
  local base_version=${version_parts[0]}
  
  local base_parts=(${base_version//./ })
  
  case "$2" in
    major)
      base_parts[0]=$((base_parts[0] + 1))
      base_parts[1]=0
      base_parts[2]=0
      ;;
    minor)
      base_parts[1]=$((base_parts[1] + 1))
      base_parts[2]=0
      ;;
    patch)
      base_parts[2]=$((base_parts[2] + 1))
      ;;
    *)
      echo "Unknown version type: $2"
      echo "Supported types: major, minor, patch"
      exit 1
      ;;
  esac

  # Construct new base version
  echo "${base_parts[0]}.${base_parts[1]}.${base_parts[2]}"
}

# Function to capitalize the first letter of each word in a string
capitalize_message() {
  local message="$1"
  echo "$message" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}'
}

# Function to create and push a new tag
create_tag() {
  local new_version=$1
  local commit_message=$2
  
  echo "Creating new tag: $new_version"
  git tag -a "$new_version" -m "$commit_message"
  git push origin "$new_version"
}

# Function to handle versioning and tagging
create_version() {
  if [ "$#" -ne 3 ]; then
    echo "Usage: $0 version <platform> <version-type> <commit-message>"
    echo "Example: $0 version xooply patch 'integrasi feature payment gateway'"
    exit 1
  fi

  PLATFORM=$1
  VERSION_TYPE=$2
  COMMIT_MESSAGE=$(capitalize_message "$3")

  # Define suffix based on platform
  case "$PLATFORM" in
    xooply)
      SUFFIX="xooply"
      ;;
    whitelabel-a)
      SUFFIX="whitelabel-a"
      ;;
    whitelabel-b)
      SUFFIX="whitelabel-b"
      ;;
    *)
      echo "Unknown platform: $PLATFORM"
      echo "Supported platforms: xooply, whitelabel-a, whitelabel-b"
      exit 1
      ;;
  esac

  # Get the latest tag based on platform
  LATEST_TAG=$(get_latest_tag "$PLATFORM" "$SUFFIX")

  # If no tags exist, start with version 0.0.0
  if [ -z "$LATEST_TAG" ]; then
    LATEST_TAG="0.0.0-$SUFFIX"
  fi

  # Increment the version
  BASE_VERSION=$(increment_version "$LATEST_TAG" "$VERSION_TYPE")

  # Create the new tag
  NEW_VERSION="${BASE_VERSION}-${SUFFIX}"
  create_tag "$NEW_VERSION" "$COMMIT_MESSAGE"
}

# Main script logic
COMMAND=$1

case "$COMMAND" in
  feature)
    create_feature_branch "$2"
    ;;
  commit)
    create_commit "$2" "$3" "$4"
    ;;
  version)
    create_version "$2" "$3" "$4"
    ;;
  *)
    echo "Unknown command: $COMMAND"
    echo "Supported commands: feature, commit, version"
    exit 1
    ;;
esac
