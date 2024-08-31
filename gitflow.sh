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

# Main script logic
COMMAND=$1

case "$COMMAND" in
  feature)
    create_feature_branch "$2"
    ;;
  commit)
    create_commit "$2" "$3" "$4"
    ;;
  *)
    echo "Unknown command: $COMMAND"
    echo "Supported commands: feature, commit"
    exit 1
    ;;
esac
