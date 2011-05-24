Reco: Ruby port of the Eco template compiler.
=============================================

Eco is a wonderful javascript template system by [Sam Stephenson](http://twitter.com/sstephenson/). For more information about eco visit [its github page](https://github.com/sstephenson/eco).

Reco let you compile Eco templates into Javascript through Ruby like this:

    javascript = Reco.compile File.read('some_template')
