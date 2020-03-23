# GoPro Metadata Extractor
This collection of scripts allows the extraction of GPS data that is recorded into the MP4 files of capable GoPro cameras (see [GoPro compatibility list](https://gopro.com/help/articles/Block/how-to-use-gps-performance-stickers#compatible)). This data can then be imported into other third-party tools to create visualizations and interactive maps, for example, [Google My Maps](https://www.google.com/mymaps).

## Usage
### Prerequisites
These scripts and the libraries they depend on are designed to run on Windows 10. You will also need to install Ubuntu on Windows Subsystem for Linux in order to run the `combine-gps.sh` script (see https://ubuntu.com/tutorials/tutorial-ubuntu-on-windows)
### Usage Steps
1. [Download this repository as a zip file](https://github.com/lawtancool/gopro-metadata-extractor/archive/master.zip) and extract the contents.
2. Copy all your GoPro MP4 files into a folder, separate from photos and other files (ex. `.THM` or `.LRV` files)
3. Drag *one* of the MP4 files onto `GPMD2CSV Folder Process.bat` to start processing that MP4 file and all other MP4 files that are located in the same directory. 
  * This will create a folder called `GoPro Metadata Extract` in the MP4 source folder. 
  * If you simply want to analyze the data of each clip individually, the `.csv` files can now be found in this folder.
4. To combine the GPS location data of all the MP4 files into a single `.csv`, ex. for usage in Google My Maps, copy the `combine-gps.sh` script into the `GoPro Metadata Extract` folder, and double-click it to run. 
  * This will create a file called `output.csv` which can then be imported into Google My Maps.

## Licenses
This software is licensed under the MIT License. See [LICENSE](LICENSE).

This software uses libraries from the FFmpeg project under the LGPLv2.1. See [ffmpeg-license.md](bin/ffmpeg-license.md)

This software uses code from https://github.com/JuanIrache/gopro-utils, which is licensed under the BSD 2-Clause License. See [gopro-utils-license.txt](bin/gopro-utils-license.txt)
