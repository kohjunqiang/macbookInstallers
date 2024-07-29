import os
import shutil
from datetime import datetime
import re

def organize_screenshots():
    # Define the source and destination directories
    desktop_path = os.path.expanduser("~/Desktop")
    screenshots_path = os.path.join(desktop_path, "Screenshots")

    # Create the Screenshots folder if it doesn't exist
    if not os.path.exists(screenshots_path):
        os.makedirs(screenshots_path)

    # Regular expression to match the screenshot filename format
    screenshot_pattern = re.compile(r'Screenshot (\d{4}-\d{2}-\d{2}) at .*\.png')

    # Counter for moved files
    moved_files = 0

    # Iterate through files on the Desktop
    for filename in os.listdir(desktop_path):
        if filename.startswith("Screenshot") and filename.endswith(".png"):
            match = screenshot_pattern.match(filename)
            if match:
                date_str = match.group(1)
                date_obj = datetime.strptime(date_str, "%Y-%m-%d")
                
                # Create year, month, day folders
                year_folder = os.path.join(screenshots_path, str(date_obj.year))
                month_folder = os.path.join(year_folder, f"{date_obj.month:02d}")
                day_folder = os.path.join(month_folder, f"{date_obj.day:02d}")
                
                # Create folders if they don't exist
                os.makedirs(day_folder, exist_ok=True)
                
                # Move the file if it's not already in the correct location
                source_path = os.path.join(desktop_path, filename)
                dest_path = os.path.join(day_folder, filename)
                if not os.path.exists(dest_path):
                    shutil.move(source_path, dest_path)
                    print(f"Moved {filename} to {dest_path}")
                    moved_files += 1
                else:
                    print(f"Skipped {filename} (already organized)")

    print(f"Screenshot organization complete! Moved {moved_files} file(s).")

if __name__ == "__main__":
    organize_screenshots()