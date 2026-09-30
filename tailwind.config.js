/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html"],
  theme: {
    extend: {
      colors: {
        haier: {
          50: '#f0f7ff',
          100: '#e0effe',
          500: '#0072CE',
          600: '#004EA2', // Primary Haier Blue
          700: '#003B7B',
          800: '#002B59',
          900: '#001A38'
        },
        powermall: {
          DEFAULT: '#E60012',
          dark: '#B8000E'
        }
      },
      fontFamily: {
        sans: ['Prompt', 'sans-serif'],
        display: ['Kanit', 'sans-serif']
      }
    }
  }
};
