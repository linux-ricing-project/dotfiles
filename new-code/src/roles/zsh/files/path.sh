# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.krew" ] ; then
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

if [ -d "/usr/local/go/bin" ] ; then
    export PATH="$PATH:/usr/local/go/bin"
fi