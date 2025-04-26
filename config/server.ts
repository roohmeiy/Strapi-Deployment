// export default ({ env }) => ({
//   host: env('HOST', '0.0.0.0'),
//   port: env.int('PORT', 1337),
//   app: {
//     keys: env.array('APP_KEYS'),
//   },
// });

export default ({ env }) => ({
  host: '0.0.0.0',
  port: 1337,
  app: {
    keys: env.array('APP_KEYS'),
  },
  url: 'http://payal-strapi-alb-1496762997.us-east-1.elb.amazonaws.com',
  admin: {
    auth: {
      secret: env('ADMIN_JWT_SECRET'),
    },
    url: '/admin',
  },
  webhooks: {
    populateRelations: false,
  },
});