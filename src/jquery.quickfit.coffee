(($, window) ->

  pluginName = 'quickfit'
  document = window.document
  defaults =
    min: 8
    max: 12
    fit_to_width: null
    tolerance: 0.02   
    wrapper: 'parent'
    truncate: false
    lazy: true
    sample_number_of_letters: 10
    sample_font_size: 12
    sample: " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@£€$%^&*()_+-=[]{};'\\:\"|,./<>?~`"

  # A helper class handling, which manages the calculation
  # of text meassurements. Will be initialized only once.
  class QuickfitHelper
    shared_instance = null

    @instance: (options) ->
      unless shared_instance
        shared_instance = new QuickfitHelper(options)
      return shared_instance

    constructor: (options) ->    
      @options = options
      @item = $('<span id="meassure"></span>')
      @item.css({ position: 'absolute', left: '-1000px', top: '-1000px', 'font-size': "#{@options.sample_font_size}px" })
      $('body').append(@item)
      @meassures = {}
      this.init_meassures() unless @options.lazy

    get_meassure: (letter) ->
      current_meassure = @meassures[letter]
      current_meassure = this.set_meassure(letter) if current_meassure == undefined
      return current_meassure

    set_meassure: (letter) ->
      text = ''
      sample_letter = if (letter==' ') then ('&nbsp;') else (letter)
      for index in [0..(@options.sample_number_of_letters-1)]
        text += sample_letter          
      @item.html(text)
      current_meassure = @item.width() / @options.sample_number_of_letters / @options.sample_font_size
      @meassures[letter] = current_meassure
      return current_meassure

    init_meassures: () ->
      for letter in @options.sample.split('')
        this.set_meassure(letter)    

  # The class running the fitting
  class Quickfit
    constructor: (@element, options) ->
      @options = $.extend {}, defaults, options

      @element = $(@element)

      @_defaults = defaults
      @_name = pluginName

      @quickfit_helper = QuickfitHelper.instance(@options)
                  
    fit: () ->    
      # Calculate the width the element should be fitted to.     
      unless @options.fit_to_width        
        element_width = @element.width()
        @options.fit_to_width = element_width - @options.tolerance*element_width

      # Get text. If the text was truncated in a previous run,
      # get the original text and set a marker, so that it
      # can be replaced if it fits this time around.    
      if text = @element.attr('data-quickfit') then truncated = true else text = @element.html() 

      text_width = 0
      for letter in text
        text_width += @quickfit_helper.get_meassure(letter)

      target_font_size = parseInt( @options.fit_to_width / text_width )
      font_size = Math.max( @options.min, Math.min( @options.max, target_font_size ) )

      # If truncate options is set, fit text into field and 
      # append three dots ('...') to the end of the text
      if @options.truncate && font_size > target_font_size
        set_text = ''
        text_width = 3*@quickfit_helper.get_meassure('.') * font_size
        index = 0
        while text_width < @options.fit_to_width && index < text.length
          letter = text[index++]
          set_text += last_letter if last_letter
          text_width += font_size*@quickfit_helper.get_meassure(letter)
          last_letter = letter

        if set_text.length+1 == text.length
          set_text = text
        else
          set_text += '...'

        @element
          .attr('data-quickfit', text)      
          .html(set_text)
          .css('font-size', "#{font_size}px")

      # else just set new font-size. Text that doesn't fit the cell will overlap
      else
        @element.html(text) if truncated
        @element.css('font-size', "#{font_size}px")
  

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn.quickfit = (options) ->
    @each () ->
      new Quickfit(@, options).fit()
        
)(jQuery, window)