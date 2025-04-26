export default ({ env }) => ({
  host: env('HOST', '0.0.0.0'),
  port: env.int('PORT', 1337),
  app: {
    keys: env.array('APP_KEYS'),
  },
// });

middlewares: {
  settings: {
    cors: {
      enabled: true,
      origin: ['http://payal-strapi-alb-1496762997.us-east-1.elb.amazonaws.com', 'http://localhost:1337', 'http://localhost:3000']
    }
  }
}
});