# Server [![Build Status](https://travis-ci.org/repla-app/Server.replaplugin.svg?branch=master)](https://travis-ci.org/repla-app/Server.replaplugin)

**Repla Server** is a plugin that comes with the [Repla macOS app](https://repla.app). It's a web development tool designed to improve your workflow in three ways:

1. ***Always* Refreshes:** Automatically refresh when you save a file, or when your build system finishes.
2. **Integrated Browser and Terminal:** One window with your web server running on the bottom, and your web app on top.
3. **Run your Web Apps by Opening a File:** Save your web app and launch it again just by opening a file.

## Implementation Details

- All of these features work immediately with your existing web apps, no dependencies or modifications necessary.
- Refresh can be configured to either use OS-level file system events, or by looking for a string in terminal output to refresh when your build system finishes.
- Repla Server uses environment inheritance to run your local web server with the same environment that you have setup in your shell.

## Quick Start Guide

1. Download and install the Repla app.
2. Run the Repla command-line tool with `repla server <your web server command>"`.
3. Add `-f` to the command to refresh when a file changes or when a your build system finishes with `-r <a string in the server command output>`.
4. Use "File" -> "Save" to save this configuration to a file.
5. Run your server again by opening the file you saved.

# Implementation Details


## Use Cases

Since Repla Server is a Unix tool, it works with most workflows:

1. Developing Web Applications in Node, Ruby, or Python using Express, Ruby on Rails, or Django.
2. Doing Frontend Development involving build systems like Gulp, Grunt, Sass, Less, or Webpack.
3. Making changes to a static blog using Jekyll or Hugo.
4. Simplify running a local web applications like Jupyter Notebooks.
