# jquery.kern

A jQuery plugin for semantically kerning text, written in CoffeeScript.

Copyright © 2013 Jordan Sexton [http://github.com/jordansexton](http://github.com/jordansexton)

MIT and GPL2 dual license, use it however you want.

Depends on [http://github.com/jquery/jquery](http://github.com/jquery/jquery)

Look at these cascading comments!

Right then, where were we?

## Introduction

Sprites, IFR, sIFR, FLIR, Cufón, `text-indent: -9999px`, TypeKit ...

From hacks to support to standards to licensing, typography on the web has come a long way.

Unfortunately, aside from getting your `@font-face` onto the damn page, the tools for manipulating and styling your pretty typefaces haven't changed much at all, and browser support for OpenType features still sucks.

Even with solid CSS3 support, you're way behind what you'd get with Photoshop or Illustrator, but responsive design means designing in the browser, and semantic markup means not littering your snazzy display text with styling tags.

Let's start by doing something about that.

## I'm 12 and what is this?

jquery.kern is a jQuery plugin that traverses the DOM and wraps words and/or letters in semantically classed tags for kerning (and general styling).

It helps you keep your markup clean while using code like this...

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
    <span class="kern-word kern-word-super">
      <span class="kern-letters">
        <span class="kern-letter kern-letter-s">S</span>
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
...so you can do pretty things like this...

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

.kern-word-super +
.kern-word-sexy {
  color: red;
}

.kern-letter-s + .kern-letter-e { margin-left: -.05em; }
.kern-letter-e + .kern-letter-x { margin-left:  .02em; }
.kern-letter-x + .kern-letter-y { margin-left:  .04em; }
```

#### Why don't you [take it for a test drive](http://jsfiddle.net/8XhZk/1/) and see what it looks like?

By default, it looks at the content after applying `text-transform` and other styles, so your pairs for _AV_ display differently than _av_ without messing with your markup.

Changing this behavior, or any of the other settings, brings us to...

## Options

First, let's go straight to the [fully annotated source](http://github.com/jordansexton/jquery.kern/blob/master/jquery.kern.js.coffee)!

```coffeescript
defaults = # Default settings that can be read/written at jQuery.fn.kern.defaults
  letters:   true      # Wrap all letters
  words:     true      # Wrap all words (successive non-whitespace characters)
  transform: true      # Use nearest CSS text-transform rules for wrapper class naming
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
  transform: true,
  tag: '<span/>',
  prefix: 'kern',
  undo: true,
  filter: function() {
    return this.nodeType === 3 && /\S/.test(this.nodeValue);
  }
};
```

## What's next?

> _"I don't know if I'm sexy enough. All this sounds like too much work."_

Damn right it does! But don't sell yourself short just yet.

What _you_ need is a **visual editor** for doing this on your own site &mdash; one that can generate reusable, semantic styles _for you_.

It just so happens that's exactly what's next on the roadmap!

So download the source, star the project if it tickles your fancy, and check back soon!
