A quick and dirty way to fit your text
======================================
jquery-quickfit-plugin is a quick and dirty solution to fit html text into its surrounding container. 

jquery-quickfit is for you, if:
* you want to resize a great number of items in a short amount of time
* can live with a small level of inaccuracy.

jquery-quickfit is not for you, if:
* you need to fit a small amount of text
* you need a 100% accurate fit of the text into its container

Usage
=====

Include jquery and jquery-quickfit int the header. 
Then simply call 

$('#yourid').quickfit(options) 

on the element you want to fit.

Demo
====

Html:

<div id="quickfit">Text to fit</div>

Javascript:
  
<script src=".../jquery.min.js" type="text/javascript"></script>
<script src="../script/jquery.quickfit.js" type="text/javascript"></script>
  
<script type="text/javascript">
  $(function() {
    $('#quickfit').quickfit();
  });
</script>

Options
=======
Name | type | default | description
min | integer | 8 | The minimum font-size the element should be sized to
max | integer | 12 | The maximum font-size the element should be sized to
truncate | boolean | false | Flag, whether the text should be truncated (shortened with an appended '...') if it doesn't fit with the minimum size.
tolerance | float | 0.15 | Adds an inside margin to the calculation. The higher the value, the smaller the chance the text will overlap its container. This value should be fiddled with, when using quickfit on different fonts.
fit_to_width | int | null | You can default quickfit a size to which the text should be fitted to. Handy when fitting a lot of elements with an equal width.
lazy | boolean | true | Performs the necessary meassurements only as needed. If set to false, there will be a performance hit on initialization.


How it works
============
Instead of using the 'resize until fit'-approach (e.g., as described [here](http://stackoverflow.com/questions/687998/auto-size-dynamic-text-to-fill-fixed-size-container)), 
which brings perfect results, but causes frequent re-layouts and thus is rather slow when dealing with multiple resizes,
quickfit calculates an onetime size invariant estimate for a text length and uses this to guesstimate the best
font-size without requiring a relayout on a subsequent fit.


Overview and Demo
=================
You can see jquery-quickfit in action [here](http://akquinet.github.com/jquery-quickfit-demo) (Resize to see effect).


License
=======
jquery-quickfit-plugin is licensed under the Apache License 2.0. 