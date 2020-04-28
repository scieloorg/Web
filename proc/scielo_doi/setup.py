#!/usr/bin/env python3
import os
import setuptools

here = os.path.abspath(os.path.dirname(__file__))
README = CHANGES = ""
# with open(os.path.join(here, "README.md")) as f:
#     README = f.read()
# with open(os.path.join(here, "CHANGES.txt")) as f:
#     CHANGES = f.read()

requires = [

]

tests_require = [
]

setuptools.setup(
    name="scielo_doi",
    version="0.1",
    author="SciELO",
    author_email="scielo-dev@googlegroups.com",
    description="",
    long_description=README + "\n\n" + CHANGES,
    long_description_content_type="text/markdown",
    license="2-clause BSD",
    packages=setuptools.find_packages(
        exclude=["*.tests", "*.tests.*", "tests.*", "tests"]
    ),
    include_package_data=True,
    extras_require={"testing": tests_require},
    install_requires=requires,
    # dependency_links=[
    # ],
    python_requires=">=3.6",
    test_suite="tests",
    classifiers=[
        "Development Status :: 2 - Pre-Alpha",
        "Environment :: Other Environment",
        "License :: OSI Approved :: BSD License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3 :: Only",
    ],

    # entry_points="",
)
