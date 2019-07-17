Simple Script to convert a [Simple Note](https://simplenote.com/) archive (unzipped) to a [Standard Notes](https://standardnotes.org/) backup file.

The [official procedure](https://standardnotes.org/help/30/how-can-i-import-my-notes-from-simplenote) is to simply convert text files one by one. Not only this is painful, but this omits tags and dates.

This script keeps creation and modifications dates, link tags, and keep the "trashed" status. It does however not reuse existing Standard Notes tags if you have any: It will recreate new ones.

# Usage 

* Download your archive from Simple Note settings
* Unzip the downloaded file. You should have a "notes" directory.
* Run the script with the path the extracted directory as argument. Redirect the output to a file of your choice.
* Import the resulting file in your Standard Note account

`ruby simplenote2standardnotes notes/ > simplenotes.txt` 