# Server [![Build Status](https://travis-ci.org/repla-app/Server.replaplugin.svg?branch=master)](https://travis-ci.org/repla-app/Server.replaplugin)

**Repla Server** is plugin for the [Repla macOS app](https://repla.app). It's a web development tool designed to improve your workflow in three ways:

1. **It *Always* Refreshes:** Instead of making a change, saving, then switching to your web browser, then refreshing, why not just have the web app automatically refresh when you save a file or your build system finishes?

Whether you're editing a simple HTML file or running a complex build system, Repla Server can always refresh everytime you make a change.
2. **It Combines the Browser and the Terminal:** Instead of having your browser showing your running web app, and a separate terminal window somewhere else running your web server, why not combine them into one window with the web app on the top, and the terminal on the bottom?
3. **Runs Local Web Servers by Opening a Document:** Instead of running your web server by typing out a long terminal command, why not just save it to a document that you can just open when you need to run your server again?

Here's how it works:

1. Download and install the Repla app.
2. Run the Repla command-line tool with `repla server <your web server command>"`
3. Configure refresh a refresh string `-r <some string to refresh>`
4. 



A few notes on how these features are implemented:

- You never have to add any dependencies to your web app in order to make Repla Servers features work.
- The main way that refresh is powered is by using system OS-level file system events, or by parsing terminal output.
- Repla Server uses environment inheritance to run your local web server with the same environment that you have setup in your shell.

## Use Cases

Since Repla Server is a Unix tool, it works with most workflows:

1. Developing Web Applications in Node, Ruby, or Python using Express, Ruby on Rails, or Django.
2. Doing Frontend Development involving Build Systems like Gulp, Grunt, Sass, Less, or Webpack
3. Running a Static Blog Locally with Jekyll, Hugo
4. Running Local Web Applications like Jupyter Notebooks