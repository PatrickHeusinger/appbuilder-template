import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'
// https://vitejs.dev/config/
export default defineConfig({
  resolve: {
    alias: [{ find: "@", replacement: path.resolve(__dirname, 'src') }],
  },
  plugins: [react()],
  server: {
    cors: false,
    proxy: {
      '/api': {
        target: 'http://127.0.0.1:8080',
        changeOrigin: true,

        secure: false,
        ws: true,
      }
    },
  },
  build: {
    rollupOptions: {
      output: {
        assetFileNames: "static/[name]-[hash][extname]",
        
        chunkFileNames: 'static/[name]-[hash].js',
        
        entryFileNames: 'static/[name]-[hash].js',
      },
    },
  },
})
