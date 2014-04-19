# jQuery.kern

A jQuery plugin for semantically kerning and styling text, written in CoffeeScript and JavaScript.

MIT and GPL2 dual license. Copyright © 2013 [Jordan Sexton](http://github.com/jordansexton)

Depends on [jQuery](http://github.com/jquery/jquery) 1.8.3+

## Introduction

Sprites, IFR, sIFR, FLIR, Cufón, `text-indent: -9999px`, TypeKit ...

From hacks to support to standards to licensing, typography on the web has come a long way.

Unfortunately, aside from getting your `@font-face` onto the damn page, the tools for manipulating and styling your pretty typefaces haven't changed much at all, and browser support for OpenType features still sucks.

Even with solid CSS3 support, you're way behind what you'd get with Photoshop or Illustrator, but responsive design means designing in the browser, and semantic markup means not littering your snazzy display text with styling tags.

Let's start by doing something about that.

## Installation

The best way to install jQuery.kern and stay up to date with releases is with [Bower](http://bower.io). This will also install jQuery for you if you don't have it already.

Open up the terminal, `cd` to your project directory, run `bower install jquery-kern --save`, and add the script to the page or template you want to use it on:
```html
<script type="text/javascript" src="path/to/bower/components/jquery-kern/jquery.kern.js"></script>
```

Alternatively, [get the latest release](https://github.com/jordansexton/jquery.kern/releases/latest) as a zip or `git clone https://github.com/jordansexton/jquery.kern.git` if you like to walk on the wild side and you're ready to rock.

## Clean gloves hide dirty hands

jquery.kern is a jQuery plugin that traverses the DOM and wraps words and/or letters in semantically classed tags for kerning (and general styling).

It helps you keep your markup neat while using code like this...

```javascript
$('h1.draw-me')
  .addClass('like-one-of-your-french-girls')
  .text('Super sexy text')
  .kern()
```

...to turn pretty code like this...

```html
<h1 class="draw-me">Sorta sexy title</h1>
```

...into fugly code like this...

```html
<h1 class="draw-me like-one-of-your-french-girls kern-kerned">
  <span class="kern-words">
    <span class="kern-word kern-word-Super">
      <span class="kern-letters">
        <span class="kern-letter kern-letter-S">S</span>
        <span class="kern-letter kern-letter-u">u</span>
        <span class="kern-letter kern-letter-p">p</span>
        <span class="kern-letter kern-letter-e">e</span>
        <span class="kern-letter kern-letter-r">r</span>
      </span>
    </span>
    <span class="kern-word kern-word-sexy">
      <span class="kern-letters">
        <span class="kern-letter kern-letter-s">s</span>
        <span class="kern-letter kern-letter-e">e</span>
        <span class="kern-letter kern-letter-x">x</span>
        <span class="kern-letter kern-letter-y">y</span>
      </span>
    </span>
    <span class="kern-word kern-word-text">
      <span class="kern-letters">
        <span class="kern-letter kern-letter-t">t</span>
        <span class="kern-letter kern-letter-e">e</span>
        <span class="kern-letter kern-letter-x">x</span>
        <span class="kern-letter kern-letter-t">t</span>
      </span>
    </span>
  </span>
</h1>
```
...so you can do cool things like this...

```css
.draw-me {
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  text-transform: lowercase;
  font-weight: 900;
  font-size: 72px;
  text-align: center;
}

.like-one-of-your-french-girls
.kern-word:nth-of-type(even) {
  font-variant: small-caps;
  font-weight: 100;
  font-size: 1.04em;
  margin: 0 -.22em 0 -.27em;
}

.kern-word-Super +
.kern-word-sexy {
  color: red;
}

.kern-letter-s + .kern-letter-e { margin-left: -.05em; }
.kern-letter-e + .kern-letter-x { margin-left:  .02em; }
.kern-letter-x + .kern-letter-y { margin-left:  .04em; }
```

#### Why don't you [take it for a test drive](http://jsfiddle.net/jordansexton/rRfdf/) and see how it looks?

~~By default~~ Optionally, it looks at the content after applying `text-transform`, `font-variant`, and other styles, so your pairs for _AV_ display differently than _av_ without messing with your markup.

^ This behavior had to be changed to an option rather than the default because Firefox doesn't support node.outerText or any other way to determine actual text content after computed styles are applied.

Adjusting this behavior, or any of the other settings, brings us to...

## Options

First, let's go straight to the [fully annotated source](http://github.com/jordansexton/jquery.kern/blob/master/jquery.kern.js.coffee)!

```coffeescript
defaults = # Default settings that can be read/written at jQuery.fn.kern.defaults
  letters:   true      # Wrap all letters
  words:     true      # Wrap all words (successive non-whitespace characters)
  transform: false     # Use nearest CSS text-transform rules for wrapper class naming; doesn't work in Firefox because node.outerText isn't supported
  tag:       '<span/>' # Tag for wrapping
  prefix:    'kern'    # Prefix for all class naming (target and wrapper)
  undo:      true      # Undo any previous calls first to prevent double wrapping
  filter:     ->       # Filter content nodes
    @nodeType is 3 and /\S/.test @nodeValue # Include text nodes that are non-empty (contain non-whitespace characters)
# ...snip...
$.extend kern, {defaults: defaults} # Make defaults readable/writable at jQuery.fn.kern.defaults
$.fn.extend {kern: kern} # Expose jQuery.fn.kern for usage at jQuery(<target>).kern(<{options}>)
```

And if [CoffeeScript](http://coffeescript.org) isn't your favorite cup of joe, there's always the [traditional flavor](http://github.com/jordansexton/jquery.kern/blob/master/jquery.kern.js):

```javascript
defaults = {
  letters: true,
  words: true,
  transform: false,
  tag: '<span/>',
  prefix: 'kern',
  undo: true,
  filter: function() {
    return this.nodeType === 3 && /\S/.test(this.nodeValue);
  }
};
```

More documentation coming soon!

## What's next?

> _"I don't know if I'm sexy enough. All this sounds like too much work."_

Damn right it does! But don't sell yourself short just yet.

What _you_ need is a **visual editor** for doing this on your own site &mdash; one that can generate reusable, semantic styles _for you_.

It just so happens that's exactly what's next on the roadmap!

So download the source, watch or star the project if it tickles your fancy, and check back soon!

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/adca3b5071fc5a2b6682e3d87c76f294 "githalytics.com")](http://githalytics.com/jordansexton/jquery.kern)
