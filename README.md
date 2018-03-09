#### *DEPRECATED (This plugin is no longer maintained*
#### Archive:

---

A quick and dirty way to fit your text
======================================
jquery-quickfit-plugin is a quick and dirty solution to fit html text into its surrounding container. 

jquery-quickfit is for you, if:

* you want to resize multiple items in a short amount of time
* you want good performance when you resize an item multiple times (e.g., on window resize)
* you want to autofit a single line of text

jquery-quickfit is not for you, if:

* you need to fit a single text once
* you want to fit a paragraph of text, spanning multiple lines

Usage
=====

Include jquery and jquery-quickfit int the header. 
Then simply call 

```html
$('#yourid').quickfit(options) 
```

on the element you want to fit.

Demo
====

Html:

```html
<div id="quickfit">Text to fit*</div>
```

Javascript:

```javascript
<script src=".../jquery.min.js" type="text/javascript" />
<script src="../script/jquery.quickfit.js" type="text/javascript" />
  
<script type="text/javascript">
  $(function() {
    $('#quickfit').quickfit();
  });
</script>
```
* in order to work correctly, this line should be styled with the white-space:nowrap option

Options
=======

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Type</th>
      <th>Default</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>min</td>
      <td>integer
      <td>8
      <td>The minimum font-size the element can be sized to</td>
    </tr>
    <tr>
      <td>max</td>
      <td>integer</td>
      <td>12</td>
      <td>The maximum font-size the element can be sized to</td>
    </tr>
    <tr>
      <td>truncate</td>
      <td>boolean</td>
      <td>false</td>
      <td>Flag, whether the text should be truncated (shortened with an appended '...') if it doesn't fit with the minimum size.</td>
    </tr>
    <tr>
      <td>tolerance</td>
      <td>float</td>
      <td>0.02</td>
      <td>Adds a padding to the calculation. The higher the value, the smaller the chance the text will overlap its container. This value should be fiddled with, when encountering problems on a certain font.</td>
    </tr>
    <tr>
      <td>width</td>
      <td>int</td>
      <td>null</td>
      <td>You can default quickfit a size to which the text should be fitted to. Handy when fitting a lot of elements with an equal width.</td>
    </tr>
  </tbody>    
</table>


How it works
============
Instead of using the [shrink-to-fit-approach](http://stackoverflow.com/questions/687998/auto-size-dynamic-text-to-fill-fixed-size-container) or the more performant [shrink-by-ratio-variant](http://stackoverflow.com/a/10053366/1318800), 
which brings perfect results, but causes frequent re-layouts and thus is rather slow when dealing with multiple resizes,
quickfit calculates an onetime size invariant estimate for a text length and uses this to guesstimate the best
font-size without requiring a relayout on a subsequent fit.

Demo
====
You can see jquery-quickfit in action [here](http://chunksnbits.github.com/jquery-quickfit/) (Resize to see effect). 

Performance
===========
Rule of the thumb testing has shown quickfit about equally performant against the shrink-to-fit-approach, when resizing a single item once.
When resizing multiple items, or a single item multiple times, jquery-quickfit outperforms shrink-to-fit significantly, see e.g., [jsperf](http://jsperf.com/jquery-quickfit-single-item-demo/11) (the test would be very similar to a window resize).

License
=======
jquery-quickfit-plugin is licensed under the Apache License 2.0. 
