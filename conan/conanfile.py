"""QWinUI3 Conan 2 recipe (2.11) — shared Release kit + find_package layout.

See docs/packaging-vcpkg-conan.md.

  conan create conan/conanfile.py --build=missing -s build_type=Release
"""

from __future__ import annotations

import os
import re

from conan import ConanFile
from conan.errors import ConanException, ConanInvalidConfiguration
from conan.tools.build import check_min_cppstd
from conan.tools.cmake import CMake, CMakeToolchain, cmake_layout
from conan.tools.files import copy, load


class QWinui3Conan(ConanFile):
    name = "qwinui3"
    version = "2.11"
    license = "MIT"
    author = "QWinUI3 contributors"
    url = "https://github.com/wuyijing-dev/QWinui3"
    homepage = "https://github.com/wuyijing-dev/QWinui3"
    description = "Fluent / WinUI 3-inspired controls for Qt 6 Quick"
    topics = ("qt", "qml", "winui", "fluent", "controls")
    settings = "os", "compiler", "build_type", "arch"
    options = {
        "shared": [True, False],
        "extras": [True, False],
        "media": [True, False],
        "webview2": [True, False],
    }
    default_options = {
        "shared": True,
        "extras": True,
        "media": False,
        "webview2": False,
    }

    def export_sources(self):
        root = os.path.normpath(os.path.join(self.recipe_folder, ".."))
        for name in ("CMakeLists.txt", "LICENSE", "COPYING"):
            copy(self, name, src=root, dst=".")
        for name in ("src", "cmake", "scripts"):
            copy(self, "*", src=os.path.join(root, name), dst=name, keep_path=True)

    def validate(self):
        check_min_cppstd(self, 17)
        if not self.options.shared:
            raise ConanInvalidConfiguration(
                "qwinui3 Conan recipe supports shared kits only (QWINUI3_BUILD_SHARED=ON)"
            )
        if self.settings.os not in ("Windows", "Linux"):
            raise ConanInvalidConfiguration("qwinui3 supports Windows and Linux only")
        if self.options.webview2 and self.settings.os != "Windows":
            raise ConanInvalidConfiguration("webview2=True is Windows-only")

    def requirements(self):
        # Pin to a ConCenter Qt 6.8.x; override in consumer profile if needed.
        self.requires("qt/6.8.3", transitive_headers=True, transitive_libs=True)

    def layout(self):
        cmake_layout(self)

    def generate(self):
        tc = CMakeToolchain(self)
        tc.variables["QWINUI3_BUILD_SHARED"] = "ON"
        tc.variables["QWINUI3_BUILD_EXAMPLES"] = "OFF"
        tc.variables["QWINUI3_BUILD_MEDIA"] = "ON" if self.options.media else "OFF"
        tc.variables["QWINUI3_BUILD_WEBVIEW2"] = "ON" if self.options.webview2 else "OFF"
        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def _project_version(self) -> str:
        text = load(self, os.path.join(self.source_folder, "CMakeLists.txt"))
        m = re.search(r'set\s*\(\s*QWINUI3_VERSION\s+"([0-9]+\.[0-9]{2})"\s*\)', text)
        if not m:
            raise ConanException("Could not parse QWINUI3_VERSION from CMakeLists.txt")
        return m.group(1)

    def package(self):
        script = os.path.join(self.source_folder, "scripts", "package_release_libs.py")
        preset = "all" if self.options.extras else "shell"
        cmd = [
            "python",
            script,
            "--shared",
            "--no-build",
            "--build-dir",
            self.build_folder,
            "--out",
            self.package_folder,
            "--preset",
            preset,
            "--version",
            self._project_version(),
            "--media",
            "on" if self.options.media else "off",
            "--webview2",
            "on" if self.options.webview2 else "off",
        ]
        self.run(" ".join(f'"{c}"' if " " in c else c for c in cmd), cwd=self.source_folder)

    def package_info(self):
        self.cpp_info.set_property("cmake_file_name", "QWinUI3")
        self.cpp_info.set_property("cmake_target_name", "QWinUI3::QWinUI3")
        self.cpp_info.bindirs = ["bin"]
        self.cpp_info.libdirs = ["lib"]
        self.cpp_info.includedirs = ["include"]
        self.cpp_info.resdirs = ["qml"]
        self.cpp_info.builddirs = ["lib/cmake/QWinUI3"]
        self.cpp_info.set_property("pkg_config_name", "qwinui3")
