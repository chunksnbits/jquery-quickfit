(($) ->

  pluginName = 'quickfit'
  defaults =
    min: 8
    max: 12
    tolerance: 0.02   
    truncate: false
    width: null
    
    sample_number_of_letters: 10
    sample_font_size: 12

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
      unless @options.width        
        element_width = @element.width()
        @options.width = element_width - @options.tolerance*element_width

      # If the text was truncated in a previous run,
      # get the original text and set a marker, so that it
      # can be replaced if it changed on this quickfit.
      if @text = @element.attr('data-quickfit') then @previously_truncated = true else @text = @element.html() 

      this.calculate_font_size()                
      this.truncate() if @options.truncate
      
      @element.css('font-size', "#{@font_size}px")
      
    calculate_font_size: () ->      
      text_width = 0
      for letter in @text
        text_width += @quickfit_helper.get_meassure(letter)
      @target_font_size = parseInt( @options.width / text_width )
      @font_size = Math.max( @options.min, Math.min( @options.max, @target_font_size ) )

    # If truncate options is set, fit text into field and 
    # append three dots ('...') to the end of the text  
    truncate: () ->  
      if @font_size > @target_font_size
        set_text = ''
        text_width = 3*@quickfit_helper.get_meassure('.') * @font_size
        index = 0
        while text_width < @options.width && index < @text.length
          letter = @text[index++]
          set_text += last_letter if last_letter
          text_width += @font_size*@quickfit_helper.get_meassure(letter)
          last_letter = letter

        if set_text.length+1 == @text.length
          set_text = @text
        else
          set_text += '...'

        @element
          .attr('data-quickfit', @text)      
          .html(set_text)
      else if @previously_truncated
        @element.html(@text)
        

  # The plugin interface method
  $.fn.quickfit = (options) ->
    @each () ->
      new Quickfit(@, options).fit()
        
)(jQuery, window)