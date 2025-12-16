#!/bin/bash
set -e
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIBS_DIR="$ROOT_DIR/libs"
QT_INSTALL_DIR="$LIBS_DIR/qt5_bin"
mkdir -p "$QT_INSTALL_DIR"

echo "📦 Installing full Qt5 locally into $QT_INSTALL_DIR ..."

# Tạo cache riêng để tránh yêu cầu sudo
APT_CACHE="$QT_INSTALL_DIR/apt-cache"
mkdir -p "$APT_CACHE/archives/partial"
echo "dir::cache::$APT_CACHE;" > apt.conf
echo "dir::state::$APT_CACHE/state;" >> apt.conf
echo "dir::etc::sourcelist /etc/apt/sources.list;" >> apt.conf
echo "dir::etc::sourceparts /etc/apt/sources.list.d;" >> apt.conf

# 1️⃣ Tải các gói Qt5 từ bản hệ (đảm bảo glibc tương thích)
apt-get -o Debug::NoLocking=true -o Dir::Cache=$APT_CACHE \
        --download-only install -y \
        qtbase5-dev qtbase5-dev-tools qtdeclarative5-dev qttools5-dev qttools5-dev-tools qtmultimedia5-dev

# 2️⃣ Giải nén tất cả .deb vào thư mục local
find "$APT_CACHE/archives" -name "*.deb" -exec dpkg-deb -x {} "$QT_INSTALL_DIR" \;

# 3️⃣ Nếu moc không chạy (bị lỗi glibc), tải moc bản tương thích Ubuntu 22.04
if ! "$QT_INSTALL_DIR/usr/lib/qt5/bin/moc" -h >/dev/null 2>&1; then
  echo "⚙️  Detected incompatible moc — replacing with glibc 2.35 compatible version..."
  cd "$QT_INSTALL_DIR"
  wget -q http://archive.ubuntu.com/ubuntu/pool/universe/q/qtbase-opensource-src/qtbase5-dev-tools_5.15.3+dfsg-2ubuntu0.1_amd64.deb
  dpkg-deb -x qtbase5-dev-tools_5.15.3+dfsg-2ubuntu0.1_amd64.deb .
  chmod +x usr/lib/qt5/bin/moc
  cd "$ROOT_DIR"
fi

# 4️⃣ Kiểm tra file chính
if [ -f "$QT_INSTALL_DIR/usr/lib/x86_64-linux-gnu/libQt5Core.so" ] && \
   [ -x "$QT_INSTALL_DIR/usr/lib/qt5/bin/moc" ]; then
  echo "✅ Full Qt5 installed successfully into $QT_INSTALL_DIR"
else
  echo "❌ Qt5 installation incomplete, missing core libs or tools"
  exit 1
fi

# 5️⃣ Xuất biến môi trường gợi ý
echo ""
echo "👉 To use it:"
echo "   export PATH=\"$QT_INSTALL_DIR/usr/lib/qt5/bin:\$PATH\""
echo "   export Qt5_DIR=\"$QT_INSTALL_DIR/usr/lib/x86_64-linux-gnu/cmake/Qt5\""
echo "   export CMAKE_PREFIX_PATH=\"$QT_INSTALL_DIR/usr/lib/x86_64-linux-gnu/cmake:\$CMAKE_PREFIX_PATH\""
