#!/usr/bin/python3
import configparser
import subprocess
import os
from typing import List, Type, Final


def moveFile(src: str, dst: str):
    subprocess.call(
        f"mv '{src}' '{dst}'",
        shell=True,
    )


def isSetCustomOptions(options: List[str], filterConfig: object) -> bool:
    for option in options:
        if filterConfig.get("Custom", option) == "":
            return False

    return True


def main():
    options: List[str] = ["PictureDir", "DocDir", "MusicDir"]
    section: str = "Default"

    # Types which is filtered
    MUSIC_TYPES: Final[List[str]] = ["mp4", "mp3", "wav", "ogg"]
    TEXT_TYPES: Final[List[str]] = ["txt", "docx", "pdf"]
    IMAGE_TYPES: Final[List[str]] = [
        "jpg",
        "png",
        "jpng",
        "gif",
        "jpeg",
        "jpe",
        "jif",
        "jfif",
        "jfi",
    ]

    """
    Path to configuration file.
    Default localization: '$HOME/.config/filter.ini'
    """
    path = os.environ["HOME"] + "/.config/filter.ini"

    filterConfig = configparser.ConfigParser(
        default_section=section, allow_no_value=True
    )
    filterConfig.read(path)

    filtedDirPath: str = filterConfig.get(section, "DownloadDir")

    if isSetCustomOptions(options, filterConfig):
        section = "Custom"

    for file in os.listdir(filtedDirPath):
        extenison: str = file.split(".")[-1]
        destDir = ""

        if extenison in MUSIC_TYPES:
            destDir = filterConfig.get(section, options[2])
        elif extenison in TEXT_TYPES:
            destDir = filterConfig.get(section, options[1])
        elif extenison in IMAGE_TYPES:
            destDir = filterConfig.get(section, options[0])

        if destDir != "":
            moveFile(
                f"{filtedDirPath}/{file}",
                f"{destDir}/{file}",
            )


if __name__ == "__main__":
    main()
