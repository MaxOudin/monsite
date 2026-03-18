# Précharge jemalloc2 pour Ruby (réduit la fragmentation mémoire)
# Nécessite libjemalloc2 dans l'Aptfile
JEMALLOC_LIB=$(find /app/.apt/usr/lib -name 'libjemalloc.so.2' 2>/dev/null | head -1)
if [ -n "$JEMALLOC_LIB" ]; then
  export LD_PRELOAD="$JEMALLOC_LIB"
fi
