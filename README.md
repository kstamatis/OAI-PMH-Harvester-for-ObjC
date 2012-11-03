OAI-PMH-Harvester-for-ObjC
==========================

*This is an ongoing work...*

Introduction
------------
OAI-PMH Objective-C harvester is an Objective C library/wrapper over the <a href="http://www.openarchives.org/OAI/openarchivesprotocol.html">OAI-PMH protocol</a>

Installation
------------
Since this is an ongoing work, no installation instructions can be given until the project ends.

Limitations
-----------
- No validation of the incoming xml
- No support for resumption tokens in the following verbs: <i>ListSets</i>
- No support for the "set" argument in <i>ListRecords</i> and </i>ListIdentifiers</i> verbs
- No support for date selective harvesting for the verbs: <i>ListIdentifiers</i> and <i>ListRecords</i>
- No support for the "description" element in <i>Identify</i> verb
- No support for the "about" element in <i>ListRecords</i> verb

Dependencies
------------
The only dependency of this project is the <a href="https://github.com/TouchCode/TouchXML">TouchXML</a> library that can be found <a href="https://github.com/TouchCode/TouchXML">here</a>.

Author
------------

Kostas Stamatis<br/>
National Documentation Center / NHRF

Licence
------------
<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/3.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">OAI-PMH ObjC Harvester</span> by <span xmlns:cc="http://creativecommons.org/ns#" property="cc:attributionName">Konstantinos Stamatis</span> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/deed.en_US">Creative Commons Attribution-ShareAlike 3.0 Unported License</a>.