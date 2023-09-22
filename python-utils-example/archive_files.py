import shutil

def zip_directory(source_dir, output_filename):
    shutil.make_archive(output_filename, 'zip', source_dir)

# Usage:
# zip_directory('source_directory_path', 'output_filename_without_extension')