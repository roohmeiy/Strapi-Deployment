// import { mergeConfig, type UserConfig } from 'vite';

// export default (config: UserConfig) => {
//   // Important: always return the modified config
//   return mergeConfig(config, {
//     resolve: {
//       alias: {
//         '@': '/src',
//       },
//     },
//   });
// };

import { mergeConfig, type UserConfig } from 'vite';

export default (config: UserConfig) => {
  // Important: always return the modified config
  return mergeConfig(config, {
    resolve: {
      alias: {
        '@': '/src',
      },
    },
    server: {
      host: true, // Listen on all addresses, including LAN and public addresses
      // If you want to specify exact allowed hosts:
      // host: ['localhost', 'your-domain.com', '192.168.1.100'], 
    },
  });
};