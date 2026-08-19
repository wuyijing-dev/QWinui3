"""Force platform-specific wheels — the package ships native QWinUI3 DLLs/.so in _kit/."""

from setuptools import setup
from setuptools.dist import Distribution


class BinaryDistribution(Distribution):
    def has_ext_modules(self) -> bool:
        return True


setup(distclass=BinaryDistribution)
