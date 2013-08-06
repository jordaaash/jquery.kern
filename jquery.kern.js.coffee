# A jQuery plugin for semantically kerning text, written in CoffeeScript.
# Copyright © 2013 Jordan Sexton http://github.com/jordansexton
# MIT and GPL2 dual license, use it however you want.
# Depends on http://github.com/jquery/jquery
# Look at these cascading comments!
# Right then, where were we?

'use strict' # Invoke strict mode, the fun is over

$ = jQuery # Assume jQuery.noConflict, make a local alias

defaults = # Default settings that can be read/written at jQuery.fn.kern.defaults
  chars:     true      # Wrap all characters
  words:     true      # Wrap all words (successive non-whitespace characters)
  transform: true      # Use nearest CSS text-transform rules for wrapper class naming
  tag:       '<span/>' # Tag for wrapping
  prefix:    'kern'    # Prefix for all class naming (target and wrapper)
  undo:      true      # Undo any previous calls first to prevent double wrapping
  filter:     ->       # Filter content nodes
    @nodeType is 3 and /\S/.test @nodeValue # Include text nodes that are non-empty (contain non-whitespace characters)

kern = (options) -> # Wrap words and characters inside text nodes in tags for styling
  settings = $.extend {}, @kern.defaults, options # Merge defaults and options non-destructively

  kern = -> # Main method
    text = $ @ # Text nodes as jQuery collection
    (text = text.map -> words @) if settings.words # Wrap words first (order of operations matters) and reduce
    (text = text.map -> chars @) if settings.chars # Wrap characters and reduce
    text # Return all the text nodes

  words = (node) -> # Wrap all words (successive non-whitespace characters)
    $(node).wrap $ settings.tag, class: "#{settings.prefix}-words" # Wrap all the words together first
    while (match = /// # Heregex: http://coffeescriptcookbook.com/chapters/regular_expressions/heregexes
        \S+            # One or more non-whitespace characters...
        (\s+)?         # ...followed by optional trailing whitespace...
        $              # ...located at the end of the text
      ///.exec node.nodeValue)? # Iterate over the string backwards for splitting the ends into new nodes
      {index, 1: whitespace} = match # Destructuring assignment: http://coffeescript.org/#destructuring
      node.splitText node.nodeValue.length - whitespace.length if whitespace? # Split off any trailing whitespace first
      split node, index, "#{settings.prefix}-word" # Reduce to return an array of nodes

  chars = (node) -> # Wrap all characters
    $(node).wrap $ settings.tag, class: "#{settings.prefix}-chars" # Wrap all the chars together first
    index = node.nodeValue.length # Iterate over the string backwards for splitting the ends into new nodes
    while --index >= 0 # Iterate through 0 inclusively to wrap the first character
      split node, index, "#{settings.prefix}-char" # Reduce to return an array of nodes

  split = (node, index, prefix) -> # Split text into a new node and wrap it
    node = node.splitText index # https://developer.mozilla.org/en-US/docs/Web/API/Text.splitText
    if settings.transform # Use node.outerText so that CSS text-transform or any other styles are applied
      wrapper = $(node).wrap($ settings.tag).parent() # Wrap first and walk up the DOM to pull the node's outerText
      wrapper.attr 'class', "#{prefix} #{prefix}-#{wrapper.prop 'outerText'}" # Use attr instead of addClass because jQuery fix eats trailing spaces: http://bugs.jquery.com/ticket/6050
    else                  # Just use node.nodeValue (semantically correct, stylistically problematic)
      $(node).wrap $ settings.tag, class: "#{prefix} #{prefix}-#{node.nodeValue}" # Use class instead of addClass because jQuery fix eats trailing spaces: http://bugs.jquery.com/ticket/6050
    node # Return the node

  if settings.undo # Undo any previous calls first to prevent double wrapping
    @find(".#{settings.prefix}-words, .#{settings.prefix}-chars").replaceWith -> $(@).text() # Replace the wrapper with the original text

  @addClass("#{settings.prefix}-kerned") # Mark the targets; use 'visibility: hidden' on unmarked elements to prevent FoUC
    .find(":not(iframe)").addBack() # Avoid missing contentDocument issue: http://bugs.jquery.com/ticket/11275
    .contents().filter(settings.filter) # Find and filter content nodes
    .map kern # Run the main method on them

  @ # Return the original targets

$.extend kern, {defaults: defaults} # Make defaults readable/writable at jQuery.fn.kern.defaults
$.fn.extend {kern: kern} # Expose jQuery.fn.kern for usage at jQuery(<target>).kern(<{options}>)