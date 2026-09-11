module.exports = {
  apps: [
    {
      name: 'personal-money-tracker-api',
      script: 'dist/src/server.js',
      instances: 'max',
      exec_mode: 'cluster',
      autorestart: true,
      watch: false,
      max_memory_restart: '500M',
      env_production: {
        NODE_ENV: 'production'
      }
    }
  ]
};
