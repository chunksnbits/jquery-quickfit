
  (function($, window) {
    var Quickfit, QuickfitHelper, defaults, document, pluginName;
    pluginName = 'quickfit';
    document = window.document;
    defaults = {
      min: 8,
      max: 12,
      fit_to_width: null,
      tolerance: 0.15,
      wrapper: 'parent',
      truncate: false,
      lazy: true,
      sample_number_of_letters: 10,
      sample_font_size: 12,
      sample: " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@£€$%^&*()_+-=[]{};'\\:\"|,./<>?~`"
    };
    QuickfitHelper = (function() {
      var shared_instance;

      shared_instance = null;

      QuickfitHelper.instance = function(options) {
        if (!shared_instance) shared_instance = new QuickfitHelper(options);
        return shared_instance;
      };

      function QuickfitHelper(options) {
        this.options = options;
        this.item = $('<span id="meassure"></span>');
        this.item.css({
          position: 'absolute',
          left: '-1000px',
          top: '-1000px',
          'font-size': "" + this.options.sample_font_size + "px"
        });
        $('body').append(this.item);
        this.meassures = {};
        if (!this.options.lazy) this.init_meassures();
      }

      QuickfitHelper.prototype.get_meassure = function(letter) {
        var current_meassure;
        current_meassure = this.meassures[letter];
        if (current_meassure === void 0) {
          current_meassure = this.set_meassure(letter);
        }
        return current_meassure;
      };

      QuickfitHelper.prototype.set_meassure = function(letter) {
        var current_meassure, index, text, _ref;
        text = '';
        for (index = 0, _ref = this.options.sample_number_of_letters - 1; 0 <= _ref ? index <= _ref : index >= _ref; 0 <= _ref ? index++ : index--) {
          text += letter;
        }
        this.item.html(text);
        current_meassure = this.item.width() / this.options.sample_number_of_letters / this.options.sample_font_size;
        this.meassures[letter] = current_meassure;
        return current_meassure;
      };

      QuickfitHelper.prototype.init_meassures = function() {
        var letter, _i, _len, _ref, _results;
        _ref = this.options.sample.split('');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          letter = _ref[_i];
          _results.push(this.set_meassure(letter));
        }
        return _results;
      };

      return QuickfitHelper;

    })();
    Quickfit = (function() {

      function Quickfit(element, options) {
        this.element = element;
        this.options = $.extend({}, defaults, options);
        this.element = $(this.element);
        this._defaults = defaults;
        this._name = pluginName;
        this.quickfit_helper = QuickfitHelper.instance(this.options);
      }

      Quickfit.prototype.fit = function() {
        var element_width, font_size, index, last_letter, letter, set_text, target_font_size, text, text_width, truncated, _i, _len;
        if (!this.options.fit_to_width) {
          element_width = this.element.width();
          this.options.fit_to_width = element_width - this.options.tolerance * element_width;
        }
        if (text = this.element.attr('data-quickfit')) {
          truncated = true;
        } else {
          text = this.element.html();
        }
        text_width = 0;
        for (_i = 0, _len = text.length; _i < _len; _i++) {
          letter = text[_i];
          text_width += this.quickfit_helper.get_meassure(letter);
        }
        target_font_size = parseInt(this.options.fit_to_width / text_width);
        font_size = Math.max(this.options.min, Math.min(this.options.max, target_font_size));
        if (this.options.truncate && font_size > target_font_size) {
          set_text = '';
          text_width = 3 * this.quickfit_helper.get_meassure('.') * font_size;
          index = 0;
          while (text_width < this.options.fit_to_width && index < text.length) {
            letter = text[index++];
            if (last_letter) set_text += last_letter;
            text_width += font_size * this.quickfit_helper.get_meassure(letter);
            last_letter = letter;
          }
          if (set_text.length + 1 === text.length) {
            set_text = text;
          } else {
            set_text += '...';
          }
          return this.element.attr('data-quickfit', text).html(set_text).css('font-size', "" + font_size + "px");
        } else {
          if (truncated) this.element.html(text);
          return this.element.css('font-size', "" + font_size + "px");
        }
      };

      return Quickfit;

    })();
    return $.fn.quickfit = function(options) {
      return this.each(function() {
        return new Quickfit(this, options).fit();
      });
    };
  })(jQuery, window);
