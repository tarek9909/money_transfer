import { env } from './config.js';
import { app } from './app.js';
import { logger } from './middleware.js';

app.listen(env.PORT, () => logger.info({ port: env.PORT, environment: env.NODE_ENV }, 'personal money tracker API listening'));
