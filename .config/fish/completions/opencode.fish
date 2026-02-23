function __fish_opencode_completions -d "Completions for opencode using yargs"
    # Get the current command line arguments
    set -l args (commandline -opc)

    # Drop the command name (opencode) so we only pass args/subcommands
    set -e args[1]

    opencode --get-yargs-completions $args 2>/dev/null | string match -v '$0'
end

complete -c opencode -e
complete -c opencode -f -a '(__fish_opencode_completions)'

