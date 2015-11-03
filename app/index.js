
var jQuery  = require('jquery');
var Hypher  = require('hypher');
var English = require('hyphenation.en-us');
var hypher  = new Hypher(English);

jQuery(function() {
    jQuery('p').each(function() {
        var i = 0, len = this.childNodes.length;
        for (; i < len; i += 1) {
            if (this.childNodes[i].nodeType === 3) {
                this.childNodes[i].nodeValue = hypher.hyphenateText(this.childNodes[i].nodeValue);
            }
        }
    });
});
