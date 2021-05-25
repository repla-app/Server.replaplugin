# Server ![Status](https://github.com/repla-app/Server.replaplugin/actions/workflows/ci.yml/badge.svg)

**Repla Server** is a plugin built-in to the [Repla macOS app](https://repla.app). It's a web development tool designed to improve your workflow in three ways:

1. **_Always_ Refresh:** Refresh automatically when you save a file, or when your build system finishes.
2. **One-Window Browser and Terminal:** Keep your browser and your terminal in one window with your web app on top, and the server output on the bottom.
3. **Run Your Web App by Opening a File:** Save your web app as a file and launch it again later just by opening it.

## Quickstart Guide

1. Download and install Repla.
2. Run your server with `repla server "<your web server command>"`.
3. Add the `-f` flag to automatically refresh when a file changes, or the `-r <a string in the server command output>` flag to refresh when a string is output to the terminal.
4. Use "File" -> "Save" to save the currently running web app to a file.
5. After closing the Repla window, run the web app again by opening the file.

## Use Cases

Repla Server works with most web development workflows:

- Developing web apps in languages like [Node](https://nodejs.org/), [Python](https://www.python.org/), or [Ruby](https://www.ruby-lang.org/); using frameworks like [Django](https://www.djangoproject.com/), [Express](https://expressjs.com/), or [Ruby on Rails](https://rubyonrails.org/).
- Doing front-end development with build systems like [Grunt](https://gruntjs.com/), [Gulp](https://gulpjs.com/), [Less](http://lesscss.org/), [Sass](https://sass-lang.com/), or [Webpack](https://webpack.js.org/).
- Maintaining static blogging engines like [Hugo](https://gohugo.io/) or [Jekyll](https://jekyllrb.com/).
- Running local web apps like [Jupyter Notebooks](https://jupyter.org/).

## How It Works

- These features work immediately with your existing web apps. No dependencies or other modifications are required.
- Refresh can either use file system events to refresh on save, or look for a terminal output string to refresh when your build system finishes.
- Environment inheritance is used to run your web server with an identical environment as your shell.
