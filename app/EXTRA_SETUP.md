# Extra Setup

* livereload server
  * [rollup.config.js] livereload({ watch: 'public', usePolling: true })
* chokidar
  * [rollup.config.js] watch: { chokidar: { usePolling: true }}