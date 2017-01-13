module.exports = {
  config: {
    fontSize: 10,
    fontFamily: 'Menlo, monospace',
    cursorShape: 'BLOCK',
    bell: false,
    base16: {
      scheme: 'ashes'
    },

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    shell: '/bin/bash',
    // for setting shell arguments (i.e. for using interactive shellArgs: ['-i'])
    // by default ['--login'] will be used
    shellArgs: ['--login'],
    // for environment variables
    env: {},
    copyOnSelect: true

  },

  plugins: [
    'hypersixteen'
  ]
};
