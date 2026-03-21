function broken_videos -d "List broken video files in a directory using ffprobe"
    # Set default directory to current directory if not provided
    set -l dir $argv[1]
    if not test -n "$dir"
        set dir (pwd)
    end

    # Check if directory exists
    if not test -d "$dir"
        echo "Error: '$dir' is not a directory"
        return 1
    end

    # Change to target directory
    pushd $dir >/dev/null

    # Define common video extensions
    set -l video_exts mp4 mkv avi mov wmv flv webm mpg mpeg

    # Find all video files in the directory (non-recursive)
    set -l files
    for ext in $video_exts
        set -l matches (find . -maxdepth 1 -type f -name "*.$ext" 2>/dev/null)
        set files $files $matches
    end

    # Check each file with ffprobe
    for file in $files
        # Skip if file doesn't exist (shouldn't happen, but safe)
        if not test -e "$file"
            continue
        end

        # Run ffprobe to check if file is valid
        ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" >/dev/null 2>&1
        if not test $status -eq 0
            # Output filename without ./ prefix
            echo (basename "$file")
        end
    end

    # Return to original directory
    popd >/dev/null
end