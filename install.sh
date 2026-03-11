#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
#  LinuxClaw Installer
#  Usage: curl -fsSL https://raw.githubusercontent.com/hshant966/linuxclaw/main/install.sh | bash
# ──────────────────────────────────────────────────────────────
set -euo pipefail

REPO="hshant966/linuxclaw"
BINARY_NAME="linuxclaw"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

# ── Colors ───────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[  OK]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
fail()  { echo -e "${RED}[FAIL]${NC}  $*"; exit 1; }

# ── Banner ───────────────────────────────────────────────────
echo -e "${BOLD}${CYAN}"
cat << 'BANNER'

  ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗ ██████╗██╗      █████╗ ██╗    ██╗
  ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝██╔════╝██║     ██╔══██╗██║    ██║
  ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ ██║     ██║     ███████║██║ █╗ ██║
  ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ ██║     ██║     ██╔══██║██║███╗██║
  ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗╚██████╗███████╗██║  ██║╚███╔███╔╝
  ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝

BANNER
echo -e "${NC}"
info "LinuxClaw Installer — The fastest self-hosted AI agent for Linux"
echo ""

# ── Platform checks ──────────────────────────────────────────
OS="$(uname -s)"
ARCH="$(uname -m)"

[ "$OS" = "Linux" ] || fail "LinuxClaw is Linux-only. Detected OS: $OS"

case "$ARCH" in
    x86_64)  ARCH_TAG="x86_64-unknown-linux-gnu" ;;
    aarch64) ARCH_TAG="aarch64-unknown-linux-gnu" ;;
    *)       fail "Unsupported architecture: $ARCH" ;;
esac

ok "Platform: $OS $ARCH ($ARCH_TAG)"

# ── Dependency checks ───────────────────────────────────────
for cmd in curl tar; do
    command -v "$cmd" &>/dev/null || fail "Required tool '$cmd' not found. Please install it."
done

# ── Fetch latest release ────────────────────────────────────
info "Fetching latest release from GitHub..."

RELEASE_URL="https://api.github.com/repos/${REPO}/releases/latest"
RELEASE_JSON="$(curl -fsSL "$RELEASE_URL" 2>/dev/null)" || {
    warn "No GitHub releases found. Building from source instead..."

    # ── Build from source fallback ──────────────────────────
    command -v cargo &>/dev/null || fail "Rust toolchain (cargo) not found. Install from https://rustup.rs"
    command -v git   &>/dev/null || fail "git not found. Please install git."

    TMPDIR="$(mktemp -d)"
    trap 'rm -rf "$TMPDIR"' EXIT

    info "Cloning repository..."
    git clone --depth 1 "https://github.com/${REPO}.git" "$TMPDIR/linuxclaw"

    info "Building release binary (this may take a few minutes)..."
    cd "$TMPDIR/linuxclaw"
    cargo build --release

    info "Installing to $INSTALL_DIR..."
    if [ -w "$INSTALL_DIR" ]; then
        cp "target/release/$BINARY_NAME" "$INSTALL_DIR/"
    else
        sudo cp "target/release/$BINARY_NAME" "$INSTALL_DIR/"
    fi

    chmod +x "$INSTALL_DIR/$BINARY_NAME"
    ok "LinuxClaw built and installed to $INSTALL_DIR/$BINARY_NAME"
    echo ""
    info "Run ${BOLD}linuxclaw init${NC} to get started."
    exit 0
}

# ── Download pre-built binary ───────────────────────────────
DOWNLOAD_URL="$(echo "$RELEASE_JSON" | grep -o "https://[^\"]*${ARCH_TAG}[^\"]*tar.gz" | head -1)"

if [ -z "$DOWNLOAD_URL" ]; then
    warn "No pre-built binary found for $ARCH_TAG. Building from source..."
    command -v cargo &>/dev/null || fail "Rust toolchain (cargo) not found. Install from https://rustup.rs"
    command -v git   &>/dev/null || fail "git not found. Please install git."

    TMPDIR="$(mktemp -d)"
    trap 'rm -rf "$TMPDIR"' EXIT

    git clone --depth 1 "https://github.com/${REPO}.git" "$TMPDIR/linuxclaw"
    cd "$TMPDIR/linuxclaw"
    cargo build --release

    if [ -w "$INSTALL_DIR" ]; then
        cp "target/release/$BINARY_NAME" "$INSTALL_DIR/"
    else
        sudo cp "target/release/$BINARY_NAME" "$INSTALL_DIR/"
    fi

    chmod +x "$INSTALL_DIR/$BINARY_NAME"
    ok "LinuxClaw built and installed to $INSTALL_DIR/$BINARY_NAME"
    echo ""
    info "Run ${BOLD}linuxclaw init${NC} to get started."
    exit 0
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

info "Downloading $DOWNLOAD_URL ..."
curl -fsSL "$DOWNLOAD_URL" -o "$TMPDIR/linuxclaw.tar.gz"
tar -xzf "$TMPDIR/linuxclaw.tar.gz" -C "$TMPDIR"

BINARY_PATH="$(find "$TMPDIR" -name "$BINARY_NAME" -type f | head -1)"
[ -n "$BINARY_PATH" ] || fail "Binary not found in release archive."

info "Installing to $INSTALL_DIR..."
if [ -w "$INSTALL_DIR" ]; then
    cp "$BINARY_PATH" "$INSTALL_DIR/$BINARY_NAME"
else
    sudo cp "$BINARY_PATH" "$INSTALL_DIR/$BINARY_NAME"
fi
chmod +x "$INSTALL_DIR/$BINARY_NAME"

# ── Done ─────────────────────────────────────────────────────
VERSION="$("$INSTALL_DIR/$BINARY_NAME" --version 2>/dev/null || echo 'v0.1.0')"
echo ""
ok "LinuxClaw ${VERSION} installed to $INSTALL_DIR/$BINARY_NAME"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo -e "    1. Run ${CYAN}linuxclaw init${NC} to create your config"
echo -e "    2. Run ${CYAN}linuxclaw chat${NC} to start chatting"
echo -e "    3. Run ${CYAN}linuxclaw --help${NC} for all commands"
echo ""
echo -e "  ${BOLD}Documentation:${NC} https://github.com/${REPO}"
echo ""
