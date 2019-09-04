# Server [![Build Status](https://travis-ci.org/repla-app/Server.replaplugin.svg?branch=master)](https://travis-ci.org/repla-app/Server.replaplugin)

**Repla Server** is a plugin that comes with the [Repla macOS app](https://repla.app). It's a web development tool designed to improve your workflow in three ways:

1. **_Always_ Refreshes:** Refresh automatically when you save a file, or when your build system finishes.
2. **One-Window Browser and Terminal:** Keep your browser and your terminal in one window with your web app on top, and the server running on the bottom.
3. **Run your Web Apps by Opening a File:** Save your running web app as a file and launch it again easily just by opening it.

## Implementation Details

- These features work immediately with your existing web apps, no dependencies or other modifications required.
- Refresh can either use file system events to refresh on save, or look for a terminal output string to refresh when your build system finishes.
- Environment inheritance is used to run your web server with an identical environment as your shell.

## Quick Start Guide

1. Download and install the Repla app.
2. Run the Repla command-line tool with `repla server "<your web server command>"`.
3. Add the `-f` flag to automatically refresh when a file changes, or the `-r <a string in the server command output>` flag to refresh when a string is output in terminal.
4. Use "File" -> "Save" to save the currently running web app to a file.
5. After closing the Repla window, run the web app again by opening the file.

## Use Cases

Repla Server is a Unix tool, so works with most web development workflows:

1. Developing web apps in languages like [Node](https://nodejs.org/), [Python](https://www.python.org/), or [Ruby](https://www.ruby-lang.org/); using frameworks like [Django](https://www.djangoproject.com/), [Express](https://expressjs.com/), or [Ruby on Rails](https://rubyonrails.org/).
2. Doing frontend development with build systems like [Grunt](https://gruntjs.com/), [Gulp](https://gulpjs.com/), [Less](http://lesscss.org/), [Sass](https://sass-lang.com/), or [Webpack](https://webpack.js.org/).
3. Maintaining static blogging engines like [Hugo](https://gohugo.io/) or [Jekyll](https://jekyllrb.com/).
4. Running local web apps like [Jupyter Notebooks](https://jupyter.org/).
