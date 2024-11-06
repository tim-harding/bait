function _bait_log
    argparse h/help s/structured 'l/level=?' 'prefix=?' 't/time=?' -- $argv
    or return

    if set -q _flag_help
        echo -n "Usage: gum log <text> ... [flags]

Log messages to output

Arguments:
  <text> ...    Text to log

Flags:
  -h, --help           Show context-sensitive help.
  -l, --level='none'   The log level to use
      --prefix=''      Prefix to print before the message
  -s, --structured     Use structured logging
  -t, --time=''        The time format to use (kitchen, layout, ansic, rfc822, etc...)
" 1>&2
        return
    end
end
