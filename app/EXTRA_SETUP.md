# Extra Setup

## Svelte
* livereload server
  * [rollup.config.js] livereload({ watch: 'public', usePolling: true })
* chokidar
  * [rollup.config.js] watch: { chokidar: { usePolling: true }}

## !!!Sapper
* node_modules > sapper > dist > dev.js
  * search for 'fs.watch'
  * (make chokidar)
  * Don't really do this, more of a note to self of why polling isn't available.