function check_empty_dirs --argument root_dir
    # Check if root_dir argument is provided
    if not set -q root_dir
        echo "Usage: check_empty_dirs <root_directory>"
        return 1
    end

    # Find all directories under root_dir (excluding the root itself)
    for dir in (find $root_dir -mindepth 1 -type d)
        # Count items in the directory
        set -l item_count (ls $dir | wc -l)
        # If count is 0, the directory is empty
        if test $item_count -eq 0
            echo $dir
        end
    end
end