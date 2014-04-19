(function () {
  'use strict';

  var $, defaults, kern, version;

  $ = jQuery;

  version = '0.1.6';

  defaults = {
    letters: true,
    words: true,
    transform: false,
    tag: '<span/>',
    prefix: 'kern',
    undo: true,
    filter: function () {
      return this.nodeType === 3 && /\S/.test(this.nodeValue);
    }
  };

  kern = function (options) {
    var letters, settings, split, words;

    settings = $.extend({}, this.kern.defaults, options);

    kern = function () {
      var text;
      text = $(this);
      if (settings.words)
        text = text.map(function () {
          return words(this);
        });
      if (settings.letters)
        text = text.map(function () {
          return letters(this);
        });
      return text;
    };

    words = function (node) {
      var cache$, index, match, whitespace;
      $(node).wrap($(settings.tag, { 'class': '' + settings.prefix + '-words' }));
      return function (accum$) {
        while (null != (match = /\S+(\s+)?$/.exec(node.nodeValue))) {
          cache$ = match;
          index = cache$.index;
          whitespace = cache$[1];
          if (null != whitespace)
            node.splitText(node.nodeValue.length - whitespace.length);
          accum$.push(split(node, index, '' + settings.prefix + '-word'));
        }
        return accum$;
      }.call(this, []);
    };

    letters = function (node) {
      var index;
      $(node).wrap($(settings.tag, { 'class': '' + settings.prefix + '-letters' }));
      index = node.nodeValue.length;
      return function (accum$) {
        while (--index >= 0) {
          accum$.push(split(node, index, '' + settings.prefix + '-letter'));
        }
        return accum$;
      }.call(this, []);
    };

    split = function (node, index, prefix) {
      var wrapper;
      node = node.splitText(index);
      if (settings.transform) {
        wrapper = $(node).wrap($(settings.tag)).parent();
        wrapper.attr('class', '' + prefix + ' ' + prefix + '-' + wrapper.prop('outerText'));
      } else {
        $(node).wrap($(settings.tag, { 'class': '' + prefix + ' ' + prefix + '-' + node.nodeValue }));
      }
      return node;
    };

    if (settings.undo)
      this.find('.' + settings.prefix + '-words, .' + settings.prefix + '-letters').replaceWith(function () {
        return $(this).text();
      });
    this.addClass('' + settings.prefix + '-kerned').find(':not(iframe)').addBack().contents().filter(settings.filter).map(kern);

    return this;
  };

  $.extend(kern, {defaults: defaults, version: version});
  $.fn.extend({ kern: kern });
}.call(this));
