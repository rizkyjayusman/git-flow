# Gitflow Script Usage Guide

## Overview

This script automates common Git workflows, including branch creation, commits with prefixes, and version tagging. It supports platform-specific tag formats and provides options to skip adding changes before committing.

## Script Commands

### 1. Create a Feature Branch

**Command:**
```bash
./gitflow.sh feature <branch-name>
```

Description: Creates a new feature branch based on the development branch.

``` bash
./gitflow.sh feature my-new-feature
```

### 2. Commit Changes
**Command:**

Description: Commits changes with a specified prefix. Optionally, skips adding changes before committing.

Options:
```bash
--skip-add: Skip git add . before committing.
```

**Prefixes:**

* `feat` or `feature`: Feature
* `fix`: Bug fix
* `refactor`: Code refactor
* `perf`: Performance improvement
* `test`: Tests
* `chore`: Maintenance tasks
* `docs`: Documentation
* `style`: Code style changes

**Usage Examples:**

* Commit with adding all changes:
```bash
./gitflow.sh commit feat 'integrasi feature payment gateway'
```

* Commit without adding changes:
```bash
./gitflow.sh commit --skip-add feat 'integrasi feature payment gateway'
```

### 3. Create and Tag a New Version

**Command:**
```bash
./gitflow.sh version <platform> <version-type> <tag-message>
```

Description: Creates a new version tag based on the latest tag for a specified platform. Increments the version according to the type and tags the commit with a message.

**Options:**

* `<platform>`: Platform name (e.g., xooply, whitelabel-a, whitelabel-b)
* `<version-type>`: Type of version increment (major, minor, patch)
* `<commit-message>`: Commit message to associate with the new tag

**Usage Examples:**

Create a patch version tag for the xooply platform:

```bash
./gitflow.sh version xooply patch 'integrasi feature payment gateway'
```

**Script Functions**

`create_feature_branch`

Checks out the development branch, pulls the latest changes, and creates a new feature branch.

`create_commit`

Commits staged changes with a prefix. Converts commit messages to lowercase and handles the --skip-add option.

`get_latest_tag`

Retrieves the latest tag for a given platform based on the suffix.

`increment_version`

Increments the version number based on the specified version type (major, minor, patch).

`capitalize_message`

Capitalizes the first letter of the commit message.

`create_tag`

Creates and pushes a new tag with a specified message.

`create_version`

Combines all functions to create and push a new version tag, considering the platform and version type.

Notes

* Ensure you are in a Git repository when running the script.
* Make sure the script has execute permissions (chmod +x gitflow.sh).
* Adjust platform suffixes and supported prefixes in the script as needed.