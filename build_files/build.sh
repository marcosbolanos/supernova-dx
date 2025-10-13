set -ouex pipefail

# Run each build script step by step
echo "Adding needed COPR repos: "
/ctx/steps/01_add_copr_repos.sh

echo "Installing packages: "
/ctx/steps/02_install_packages.sh
