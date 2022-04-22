function do
    if test "$argv" != ""
        $argv & disown
    else
        echo "No args specified"
    end
end
