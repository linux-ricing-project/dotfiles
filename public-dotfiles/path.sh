# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# loading CESAR local scripts
if [ -d "$HOME/bin/CESAR" ] ; then
    PATH="$HOME/bin/CESAR:$PATH"
fi