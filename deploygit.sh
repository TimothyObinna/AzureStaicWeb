#!/bin/bash

# Exit immediately if a command fails
set -e

# ==============================
# CONFIGURATION VARIABLES
# ==============================
REPO_URL="https://github.com/TimothyObinna/AzureStaicWeb.git"
BRANCH="master"
COMMIT_MESSAGE="🚀 Latest commit - Static Website Deployment"

# ==============================
# LOGGING FUNCTIONS
# ==============================
log() {
  echo -e "\n[INFO] $1"
}

error() {
  echo -e "\n[ERROR] $1"
  exit 1
}

# ==============================
# CHECK PREREQUISITES
# ==============================
command -v git >/dev/null 2>&1 || error "Git is not installed."

# ==============================
# INITIALIZE GIT REPOSITORY
# ==============================
if [ ! -d ".git" ]; then
  log "Initializing Git repository..."
  git init
else
  log "Git repository already initialized."
fi

# ==============================
# ADD REMOTE REPOSITORY
# ==============================
if git remote | grep -q "origin"; then
  log "Remote 'origin' already exists."
else
  log "Adding remote repository..."
  git remote add origin "$REPO_URL"
fi

# ==============================
# ADD FILES
# ==============================
log "Adding files to staging..."
git add .

# ==============================
# COMMIT CHANGES
# ==============================
if git diff --cached --quiet; then
  log "No changes to commit."
else
  log "Committing changes..."
  git commit -m "$COMMIT_MESSAGE"
fi

# ==============================
# SET DEFAULT BRANCH
# ==============================
log "Setting default branch to $BRANCH..."
git branch -M "$BRANCH"


log "Pulling latest changes from GitHub..."
git pull origin "$BRANCH" --allow-unrelated-histories || true

# ==============================
# PUSH TO GITHUB
# ==============================
log "Pushing to GitHub..."
git push -u origin "$BRANCH"

# ==============================
# SUCCESS MESSAGE
# ==============================
echo -e "\n====================================="
echo "🎉 Deployment to GitHub Successful!"
echo "📦 Repository: $REPO_URL"
echo "🌿 Branch: $BRANCH"
echo "=====================================\n"