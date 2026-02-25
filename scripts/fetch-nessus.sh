#!/usr/bin/env bash
set -euo pipefail

VERSION="10.11.2"
OUTDIR="pkgs/nessus"

mkdir -p "$OUTDIR"

ARCH="$(uname -m)"

if [[ "$ARCH" == "aarch64" ]]; then
    FILE="Nessus-${VERSION}-ubuntu1804_aarch64.deb"
    URL="https://www.tenable.com/downloads/api/v2/pages/nessus/files/${FILE}"
    SHA256_EXPECTED="12ba8312b8409899d6fc78fbe0f2392040db7b490cf4f214891be32d9be0f1bd"
elif [[ "$ARCH" == "x86_64" ]]; then
    FILE="Nessus-${VERSION}-ubuntu1604_amd64.deb"
    URL="https://www.tenable.com/downloads/api/v2/pages/nessus/files/${FILE}"
    SHA256_EXPECTED="d48278c2989dff0b8c86f71bc33084d645e310aef3612ed3f2cd3ad23e2e4bf6"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

FILEPATH="$OUTDIR/$FILE"

verify_hash() {
    local hash
    hash="$(sha256sum "$FILEPATH" | awk '{print $1}')"
    if [[ "$hash" != "$SHA256_EXPECTED" ]]; then
        echo "Hash mismatch!"
        echo "Expected: $SHA256_EXPECTED"
        echo "Got:      $hash"
        return 1
    fi
    return 0
}

if [[ -f "$FILEPATH" && -s "$FILEPATH" ]]; then
    echo "Installer already exists. Verifying integrity..."
    if verify_hash; then
        echo "Hash OK. Skipping download."
        exit 0
    else
        echo "File corrupted or version mismatch. Re-downloading..."
        rm -f "$FILEPATH"
    fi
fi

echo "Downloading $FILE..."
curl --fail --location --output "$FILEPATH" "$URL"

echo "Verifying download..."
if verify_hash; then
    echo "Download verified successfully."
else
    echo "Downloaded file failed hash check."
    rm -f "$FILEPATH"
    exit 1
fi

echo "Done."