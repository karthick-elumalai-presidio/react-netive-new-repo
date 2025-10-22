/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./app/**/*.{js,ts,tsx}', './components/**/*.{js,ts,tsx}'],

  presets: [require('nativewind/preset')],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#007bff', // dark mode primary
          light: '#0046ad', // light mode primary
          lighten: '#007bff67',
        },
        background: {
          DEFAULT: '#000', // dark mode
          light: '#fff', // light mode
        },
        foreground: {
          DEFAULT: '#fff', // dark mode text
          light: '#000', // light mode text
          secondary: {
            DEFAULT: '#ffffff73', // dark mode
            light: '#00000073', // light mode
          },
        },
        border: {
          DEFAULT: '#e2e8f0',
          gray: '#e2e8f059',
          table: {
            DEFAULT: '#e2e8f0', // dark mode
            light: '#90a1b9', // light mode
          },
        },
        success: '#28a745',
        error: '#e7000b',
        warning: '#ffa500',
        track: {
          DEFAULT: '#343434', // dark mode
          light: '#c2c2c2', // light mode
        },
        collapse: {
          header: {
            DEFAULT: '#232323', // dark mode
            light: '#f8f9fa', // light mode
          },
          content: {
            DEFAULT: '#232323', // dark mode
            light: '#f8f9fa', // light mode
          },
        },
        sider: {
          selected: {
            DEFAULT: '#232323', // dark mode
            light: '#0046ad', // light mode (primary)
          },
          dot: {
            DEFAULT: '#007bff', // dark mode (primary)
            light: '#fff', // light mode
          },
        },
        highlight: {
          DEFAULT: '#fff', // dark mode
          light: '#0046ad', // light mode (primary)
        },
        switch: {
          unchecked: '#90a1b9',
        },
        status: {
          dot: '#80808070',
        },
        actions: {
          hover: '#eeebeb',
        },
      },
      fontFamily: {
        sans: ['Noto Sans', 'sans-serif'],
      },
      fontSize: {
        base: '14px',
      },
      borderRadius: {
        DEFAULT: '4px',
      },
      boxShadow: {
        primary: '0 10px 40px rgb(0 69 173 / 0.5)',
        light: '0 4px 12px rgb(0 0 0 / 0.1)',
      },
      spacing: {
        'tag-gap': '8px',
      },
    },
  },
  plugins: [],
};